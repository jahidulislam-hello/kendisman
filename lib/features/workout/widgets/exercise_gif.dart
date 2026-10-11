import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

/// Library names that predate the animation pack, pointed at the clip with
/// the same movement. Keys and values are normalized exercise names.
const _animationNameAliases = {
  'barbellbacksquat': 'barbellhighbarsquat',
  'barbellrow': 'barbellbentoverrow',
  'bodyweightsquat': 'squat',
  'conventionaldeadlift': 'barbelldeadlift',
  'dumbbellbicepcurl': 'dumbbellbicepscurl',
  'dumbbellshoulderpress': 'dumbbellseatedshoulderpress',
  'latpulldown': 'cablepulldown',
  'legpress': 'sled45legpress',
  'overheadpress': 'barbellstandingmilitarypress',
  'plank': 'frontplank',
  'romaniandeadlift': 'barbellstraightlegdeadlift',
  'tricepdip': 'tricepsdip',
};

String _normExerciseName(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

/// 180p clip used as a list and grid thumbnail.
String? exerciseThumbnailUrl(Map<String, dynamic> row) {
  for (final key in ['gif_url_180', 'gif_url', 'gif_url_360', 'image_url']) {
    final value = row[key];
    if (value is String && value.isNotEmpty) return value;
  }
  return null;
}

/// 360p clip used when one exercise is on screen.
String? exerciseDemoUrl(Map<String, dynamic> row) {
  for (final key in ['gif_url_360', 'gif_url', 'gif_url_180', 'image_url']) {
    final value = row[key];
    if (value is String && value.isNotEmpty) return value;
  }
  return null;
}

Map<String, dynamic>? _rowForNorm(List<Map<String, dynamic>> rows, String norm) {
  for (final row in rows) {
    if (_normExerciseName(row['name'] as String? ?? '') == norm) return row;
  }
  return null;
}

/// Resolves a demonstration GIF from the exercise catalog by name.
String? exerciseThumbnailForName(List<Map<String, dynamic>>? rows, String name) {
  if (rows == null || name.trim().isEmpty) return null;
  final direct = _rowForNorm(rows, _normExerciseName(name));
  final directUrl = direct == null ? null : exerciseThumbnailUrl(direct);
  if (directUrl != null) return directUrl;
  final alias = _animationNameAliases[_normExerciseName(name)];
  if (alias == null) return null;
  final linked = _rowForNorm(rows, alias);
  return linked == null ? null : exerciseThumbnailUrl(linked);
}

class ExerciseGif extends ConsumerWidget {
  const ExerciseGif({
    super.key,
    required this.name,
    this.gifUrl,
    this.size = 72,
    this.borderRadius = 12,
    this.expand = false,
  });

  final String name;
  final String? gifUrl;
  final double size;
  final double borderRadius;
  final bool expand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final resolved = (gifUrl != null && gifUrl!.isNotEmpty)
        ? gifUrl
        : exerciseThumbnailForName(
            ref.watch(exerciseCatalogProvider).value,
            name,
          );

    final image = resolved == null
        ? const SizedBox.shrink()
        : CachedNetworkImage(
            imageUrl: resolved,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 120),
            placeholder: (_, __) => const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => const SizedBox.shrink(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: colors.background,
        child: expand
            ? SizedBox.expand(child: image)
            : SizedBox(width: size, height: size, child: image),
      ),
    );
  }
}
