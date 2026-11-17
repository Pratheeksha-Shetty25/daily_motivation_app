
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesNotifier extends Notifier<List<dynamic>> {
  @override
  List<dynamic> build() {
    return [];
  }

  void toggleFavourite(dynamic quote) {
    if (state.contains(quote)) {
      state = state.where((item) => item != quote).toList();
    } else {
      state = [...state, quote];
    }
  }
}

final favouritesProvider =
    NotifierProvider<FavouritesNotifier, List<dynamic>>(
  FavouritesNotifier.new,
);
