/// CRUD over the configured [ServiceInstance]s, backed by [ConfigStore]
/// (non-secret fields) and [SecureStore] (the credential). Every write is
/// validated at the boundary and every read/write is immutable — callers
/// get back new lists/instances, never a mutated one (spec §5, §11).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/config_store.dart';
import 'package:arrstack/core/storage/secure_store.dart';
import 'package:json_annotation/json_annotation.dart';

/// CRUD operations over configured service instances.
abstract interface class InstanceRepository {
  Future<Result<List<ServiceInstance>>> list();

  Future<Result<ServiceInstance>> getById(String id);

  /// Adds a new instance, optionally storing its credential in
  /// [SecureStore]. Fails if [instance] doesn't validate (see
  /// [validateServiceInstance]) or an instance with the same id exists.
  Future<Result<ServiceInstance>> add(
    ServiceInstance instance, {
    ServiceCredential? credential,
  });

  /// Replaces the stored instance with matching id. Pass [credential] to
  /// also update the stored secret; omit it to leave the existing
  /// credential untouched.
  Future<Result<ServiceInstance>> update(
    ServiceInstance instance, {
    ServiceCredential? credential,
  });

  /// Removes the instance and its credential.
  Future<Result<void>> delete(String id);

  /// Marks [id] as the default instance (of its `ServiceType`) and clears
  /// `isDefault` on any other instance of the same type.
  Future<Result<ServiceInstance>> setDefault(String id);
}

/// [InstanceRepository] backed by [ConfigStore] + [SecureStore].
class ConfigStoreInstanceRepository implements InstanceRepository {
  const ConfigStoreInstanceRepository(this._configStore, this._secureStore);

  final ConfigStore _configStore;
  final SecureStore _secureStore;

  @override
  Future<Result<List<ServiceInstance>>> list() async {
    // A corrupted/legacy stored instance must degrade to an Err, never throw
    // across this boundary (spec §5). Decode failures surface as different
    // types: FormatException, TypeError (wrong shape), ArgumentError (unknown
    // enum value, e.g. a post-v1 ServiceType), or CheckedFromJsonException —
    // catch the whole family.
    try {
      final raw = await _configStore.readInstances();
      final instances = raw.map(ServiceInstance.fromJson).toList();
      return Ok(List.unmodifiable(instances));
    } on FormatException catch (error) {
      return _corrupted(error);
    } on CheckedFromJsonException catch (error) {
      return _corrupted(error);
    } on TypeError catch (error) {
      return _corrupted(error);
    } on ArgumentError catch (error) {
      return _corrupted(error);
    } catch (error) {
      return _storageError(error);
    }
  }

  Err<List<ServiceInstance>> _corrupted(Object error) => Err(
    ValidationError(
      cause: error,
      userMessage: 'Saved service configuration is corrupted.',
    ),
  );

  Err<T> _storageError<T>(Object error) => Err(
    StorageError(cause: error, userMessage: 'Failed to access local storage.'),
  );

  @override
  Future<Result<ServiceInstance>> getById(String id) async {
    final listResult = await list();
    switch (listResult) {
      case Ok(:final value):
        return _findById(value, id);
      case Err(:final error):
        return Err(error);
    }
  }

  @override
  Future<Result<ServiceInstance>> add(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async {
    final validation = validateServiceInstance(instance);
    if (validation case Err(:final error)) return Err(error);

    final listResult = await list();
    final List<ServiceInstance> current;
    switch (listResult) {
      case Ok(:final value):
        current = value;
      case Err(:final error):
        return Err(error);
    }

    if (current.any((existing) => existing.id == instance.id)) {
      return const Err(
        ValidationError(
          field: 'id',
          userMessage: 'An instance with this id already exists.',
        ),
      );
    }

    final next = [
      if (instance.isDefault) ..._clearDefaultsOf(current, instance),
      if (!instance.isDefault) ...current,
      instance,
    ];
    // Write the secret first so we never persist an instance that has no
    // matching credential (which would silently break auth). An orphaned
    // credential from a later persist failure is harmless and overwritten.
    try {
      if (credential != null) {
        await _secureStore.writeCredential(instance.id, credential);
      }
      await _persist(next);
      return Ok(instance);
    } catch (error) {
      return _storageError(error);
    }
  }

  @override
  Future<Result<ServiceInstance>> update(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async {
    final validation = validateServiceInstance(instance);
    if (validation case Err(:final error)) return Err(error);

    final listResult = await list();
    final List<ServiceInstance> current;
    switch (listResult) {
      case Ok(:final value):
        current = value;
      case Err(:final error):
        return Err(error);
    }

    if (!current.any((existing) => existing.id == instance.id)) {
      return const Err(
        NotFoundError(userMessage: 'No instance found with this id.'),
      );
    }

    final withoutTarget = current
        .where((existing) => existing.id != instance.id)
        .toList();
    final cleared = instance.isDefault
        ? _clearDefaultsOf(withoutTarget, instance)
        : withoutTarget;
    final next = [...cleared, instance];

    // Credential before config, for the same reason as add().
    try {
      if (credential != null) {
        await _secureStore.writeCredential(instance.id, credential);
      }
      await _persist(next);
      return Ok(instance);
    } catch (error) {
      return _storageError(error);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    final listResult = await list();
    final List<ServiceInstance> current;
    switch (listResult) {
      case Ok(:final value):
        current = value;
      case Err(:final error):
        return Err(error);
    }

    final next = current.where((instance) => instance.id != id).toList();

    try {
      await _persist(next);
      await _secureStore.deleteCredential(id);
      return const Ok(null);
    } catch (error) {
      return _storageError(error);
    }
  }

  @override
  Future<Result<ServiceInstance>> setDefault(String id) async {
    final listResult = await list();
    final List<ServiceInstance> current;
    switch (listResult) {
      case Ok(:final value):
        current = value;
      case Err(:final error):
        return Err(error);
    }

    final targetResult = _findById(current, id);
    final ServiceInstance target;
    switch (targetResult) {
      case Ok(:final value):
        target = value;
      case Err(:final error):
        return Err(error);
    }

    final updatedTarget = target.copyWith(isDefault: true);

    final next = current
        .map(
          (instance) => instance.id == id
              ? updatedTarget
              : (instance.serviceType == target.serviceType
                    ? instance.copyWith(isDefault: false)
                    : instance),
        )
        .toList();

    try {
      await _persist(next);
      return Ok(updatedTarget);
    } catch (error) {
      return _storageError(error);
    }
  }

  /// Clears `isDefault` on every other instance of the same service type as
  /// [incoming], since only one default is allowed per type.
  List<ServiceInstance> _clearDefaultsOf(
    List<ServiceInstance> instances,
    ServiceInstance incoming,
  ) {
    return instances
        .map(
          (instance) =>
              instance.serviceType == incoming.serviceType && instance.isDefault
              ? instance.copyWith(isDefault: false)
              : instance,
        )
        .toList();
  }

  Result<ServiceInstance> _findById(
    List<ServiceInstance> instances,
    String id,
  ) {
    for (final instance in instances) {
      if (instance.id == id) return Ok(instance);
    }
    return const Err(
      NotFoundError(userMessage: 'No instance found with this id.'),
    );
  }

  Future<void> _persist(List<ServiceInstance> instances) {
    return _configStore.writeInstances(
      instances.map((instance) => instance.toJson()).toList(),
    );
  }
}
