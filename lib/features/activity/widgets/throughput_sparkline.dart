/// The Transfers lens's "last 60 min" throughput chart (spec screen 2h):
/// 12 five-minute bars stepping from `accent-800` (oldest) to `accent`
/// (most recent), with a caption showing the live and peak speeds.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:flutter/material.dart';

const int _bucketCount = 12;
const Duration _bucketDuration = Duration(minutes: 5); // 12 * 5 = 60 min
const double _sparklineHeight = 52;

/// Buckets [samples] into 12 five-minute windows covering the hour up to
/// [now] (defaults to `DateTime.now()`), each bucket holding the average
/// download speed of the samples that fall in it (0 for an empty bucket).
/// Pure — unit-testable without a widget tree. Index 0 is the oldest
/// bucket, index 11 the most recent.
List<double> bucketThroughputSamples(
  List<ThroughputSample> samples, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final windowStart = reference.subtract(_bucketDuration * _bucketCount);

  final sums = List<double>.filled(_bucketCount, 0);
  final counts = List<int>.filled(_bucketCount, 0);

  for (final sample in samples) {
    final offset = sample.timestamp.difference(windowStart);
    if (offset.isNegative) continue;
    final index = (offset.inMilliseconds / _bucketDuration.inMilliseconds)
        .floor();
    if (index < 0 || index >= _bucketCount) continue;
    sums[index] += sample.dlSpeedBytesPerSecond;
    counts[index]++;
  }

  return [
    for (var i = 0; i < _bucketCount; i++)
      counts[i] == 0 ? 0 : sums[i] / counts[i],
  ];
}

class ThroughputSparkline extends StatelessWidget {
  const ThroughputSparkline({required this.samples, super.key});

  final List<ThroughputSample> samples;

  static const List<Color> _barColors = [
    AppColors.a800,
    AppColors.a700,
    AppColors.a600,
    AppColors.a500,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final buckets = bucketThroughputSamples(samples);
    final peak = buckets.fold<double>(0, (m, v) => v > m ? v : m);
    final nowSpeed = samples.isEmpty ? 0 : samples.last.dlSpeedBytesPerSecond;
    final onSurfaceMuted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _sparklineHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < buckets.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  child: Container(
                    height: peak == 0
                        ? 1
                        : (buckets[i] / peak * _sparklineHeight).clamp(
                            1,
                            _sparklineHeight,
                          ),
                    decoration: BoxDecoration(
                      color: _colorFor(i, buckets.length),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last 60 min · ↓ ${FormatUtils.formatSpeed(nowSpeed)} now',
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
            Text(
              'peak ${FormatUtils.formatSpeed(peak.round())}',
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
          ],
        ),
      ],
    );
  }

  Color _colorFor(int index, int total) {
    final t = total <= 1 ? 0.0 : index / (total - 1);
    final scaled = t * (_barColors.length - 1);
    final lower = scaled.floor().clamp(0, _barColors.length - 1);
    final upper = scaled.ceil().clamp(0, _barColors.length - 1);
    return Color.lerp(_barColors[lower], _barColors[upper], scaled - lower)!;
  }
}
