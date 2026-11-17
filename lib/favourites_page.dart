
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favourites_provider.dart';

class FavouritesPage extends ConsumerWidget {
  // Old setState version kept for reference:
  // final List<dynamic> favouriteQuotes;
  //
  // const FavouritesPage({
  //   super.key,
  //   required this.favouriteQuotes,
  // });

  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteQuotes = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Quotes'),
      ),
      body: ListView.builder(
        itemCount: favouriteQuotes.length,
        itemBuilder: (context, index) {
          final item = favouriteQuotes[index];

          return ListTile(
            title: Text(item['quote']),
            subtitle: Text('- ${item['author']}'),
          );
        },
      ),
    );
  }
}
