import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeerrServiceProfile', () {
    test('parses from json', () {
      final profile = SeerrServiceProfile.fromJson({
        'id': 6,
        'name': 'HD-1080p',
      });
      expect(profile.id, 6);
      expect(profile.name, 'HD-1080p');
    });
  });

  group('SeerrServiceRootFolder', () {
    test('parses free/total space when present', () {
      final folder = SeerrServiceRootFolder.fromJson({
        'path': '/data/media/movies',
        'freeSpace': 2400000000000,
        'totalSpace': 18000000000000,
      });
      expect(folder.path, '/data/media/movies');
      expect(folder.freeSpace, 2400000000000);
      expect(folder.totalSpace, 18000000000000);
    });

    test('tolerates missing free/total space', () {
      final folder = SeerrServiceRootFolder.fromJson({
        'path': '/data/media/movies',
      });
      expect(folder.freeSpace, isNull);
      expect(folder.totalSpace, isNull);
    });
  });

  group('SeerrServiceSummary', () {
    test('parses id and isDefault', () {
      final summary = SeerrServiceSummary.fromJson({
        'id': 2,
        'isDefault': true,
      });
      expect(summary.id, 2);
      expect(summary.isDefault, isTrue);
    });

    test('parses a non-default entry', () {
      final summary = SeerrServiceSummary.fromJson({
        'id': 0,
        'isDefault': false,
      });
      expect(summary.id, 0);
      expect(summary.isDefault, isFalse);
    });
  });

  group('SeerrServiceDetails', () {
    test('parses nested profiles and rootFolders', () {
      final details = SeerrServiceDetails.fromJson({
        'profiles': [
          {'id': 6, 'name': 'HD-1080p'},
        ],
        'rootFolders': [
          {'path': '/data/media/movies', 'freeSpace': 100, 'totalSpace': 200},
        ],
      });
      expect(details.profiles, hasLength(1));
      expect(details.profiles.first.name, 'HD-1080p');
      expect(details.rootFolders, hasLength(1));
      expect(details.rootFolders.first.path, '/data/media/movies');
    });

    test('defaults to empty lists when both fields are absent', () {
      final details = SeerrServiceDetails.fromJson(const {});
      expect(details.profiles, isEmpty);
      expect(details.rootFolders, isEmpty);
    });

    test('parses activeProfileId and activeDirectory when present', () {
      final details = SeerrServiceDetails.fromJson({
        'profiles': [
          {'id': 6, 'name': 'HD-1080p'},
        ],
        'rootFolders': [
          {'path': '/data/media/movies'},
        ],
        'activeProfileId': 6,
        'activeDirectory': '/data/media/movies',
      });
      expect(details.activeProfileId, 6);
      expect(details.activeDirectory, '/data/media/movies');
    });

    test('tolerates missing activeProfileId/activeDirectory', () {
      final details = SeerrServiceDetails.fromJson({
        'profiles': <Map<String, dynamic>>[],
        'rootFolders': <Map<String, dynamic>>[],
      });
      expect(details.activeProfileId, isNull);
      expect(details.activeDirectory, isNull);
    });
  });
}
