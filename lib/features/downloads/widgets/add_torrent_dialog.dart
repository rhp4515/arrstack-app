/// Dialog to add a new torrent via magnet link or URL (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTorrentDialog extends ConsumerStatefulWidget {
  const AddTorrentDialog({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<AddTorrentDialog> createState() => _AddTorrentDialogState();
}

class _AddTorrentDialogState extends ConsumerState<AddTorrentDialog> {
  final _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Torrent'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Paste a magnet link or .torrent URL below:'),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'magnet:?xt=urn:btih:...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final url = _controller.text.trim();
    if (url.isEmpty) return;

    setState(() => _isSaving = true);
    final repository = await ref.read(
      qbitRepositoryProvider(widget.instanceId).future,
    );
    final result = await repository.addTorrent(url);

    if (mounted) {
      setState(() => _isSaving = false);
      if (result.isOk) {
        ref.invalidate(qbitTorrentsProvider(widget.instanceId));
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Torrent added.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${result.errorOrNull?.userMessage}')),
        );
      }
    }
  }
}
