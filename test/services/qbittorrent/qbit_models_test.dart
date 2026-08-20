// QbitTorrent parsing against a realistic /api/v2/torrents/info object.
// qBittorrent sends several boolean flags (seq_dl, f_l_piece_prio, ...) that
// are NOT numbers; a model that types them as int throws
// "type 'bool' is not a subtype of type 'num'" and drops every torrent,
// leaving the Downloads tab empty. Extra/unknown fields must be ignored.

import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> torrentJson() => {
    'hash': 'abc123',
    'name': 'The Big Bang Theory S10E11 1080p',
    'size': 510510592,
    'progress': 0.33,
    'dlspeed': 8388608,
    'upspeed': 2764800,
    'priority': 0,
    'num_seeds': 5,
    'num_leechs': 2,
    'num_incomplete': 10,
    'ratio': 0.33,
    'eta': 8640000,
    'state': 'stalledDL',
    'tracker': 'https://open.demonii.com:443/announce',
    // Booleans that previously crashed the int-typed model:
    'seq_dl': true,
    'f_l_piece_prio': false,
    'super_seeding': false,
    'force_start': false,
    'auto_tmm': true,
    'added_on': 1700000000,
    'completion_on': -1,
    'category': 'tv',
    'tags': '',
    'save_path': '/downloads',
    'time_active': 3600,
    'last_activity': 1700000000,
  };

  group('QbitTorrent.fromJson', () {
    test('parses a torrent whose seq_dl is a bool and ignores extra fields', () {
      final torrent = QbitTorrent.fromJson(torrentJson());

      expect(torrent.name, 'The Big Bang Theory S10E11 1080p');
      expect(torrent.size, 510510592);
      expect(torrent.progress, closeTo(0.33, 0.001));
      expect(torrent.state, 'stalledDL');
      expect(torrent.tracker, 'https://open.demonii.com:443/announce');
      expect(torrent.ratio, closeTo(0.33, 0.001));
    });

    test('defaults tracker to empty string when the field is absent', () {
      final json = torrentJson()..remove('tracker');
      final torrent = QbitTorrent.fromJson(json);
      expect(torrent.tracker, '');
    });
  });
}
