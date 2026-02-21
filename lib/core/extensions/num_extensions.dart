import 'package:flutter/material.dart';

extension RatingColorEx on num {
  /// Returns a Metacritic-style color based on the rating value.
  /// >= 4.5: Green (Color(0xFF66CC33))
  /// >= 3.0: Yellow (Color(0xFFFFCC33))
  /// < 3.0: Red (Color(0xFFFF0000))
  Color get ratingColor {
    if (this >= 4.5) return const Color(0xFF66CC33);
    if (this >= 3.0) return const Color(0xFFFFCC33);
    return const Color(0xFFFF0000);
  }
}
