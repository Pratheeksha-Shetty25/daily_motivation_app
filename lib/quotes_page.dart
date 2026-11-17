
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'favourites_page.dart';
import 'favourites_provider.dart';

class QuotesPage extends ConsumerStatefulWidget {
  const QuotesPage({super.key});

  @override
  ConsumerState<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends ConsumerState<QuotesPage> {
  // Old setState favourite list kept for reference:
  // List<dynamic> favouriteQuotes = [];

  List<dynamic> quotes = [];
  int skip = 0;
  bool isLoadingMore = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    final url = Uri.parse(
      'https://dummyjson.com/quotes?limit=5&skip=0',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        quotes = data['quotes'];
      });
    }
  }

  Future<void> loadMoreQuotes() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    skip += 5;

    final url = Uri.parse(
      'https://dummyjson.com/quotes?limit=5&skip=$skip',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        quotes.addAll(data['quotes']);
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favouriteQuotes = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivational Quotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search quotes or authors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  searchQuery = text;
                });
              },
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final filteredQuotes = quotes.where((item) {
                  final quoteText =
                      item['quote'].toString().toLowerCase();
                  final authorName =
                      item['author'].toString().toLowerCase();

                  return quoteText.contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      authorName.contains(
                        searchQuery.toLowerCase(),
                      );
                }).toList();

                return ListView.builder(
                  itemCount: filteredQuotes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filteredQuotes.length) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: isLoadingMore
                              ? null
                              : loadMoreQuotes,
                          child: Text(
                            isLoadingMore
                                ? 'Loading...'
                                : 'Load More',
                          ),
                        ),
                      );
                    }

                    final item = filteredQuotes[index];

                    return ListTile(
                      title: Text(item['quote']),
                      subtitle: Text('- ${item['author']}'),
                      trailing: IconButton(
                        icon: Icon(
                          favouriteQuotes.contains(item)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favouriteQuotes.contains(item)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          ref
                              .read(favouritesProvider.notifier)
                              .toggleFavourite(item);

                          // Old setState implementation kept for reference:
                          // setState(() {
                          //   if (favouriteQuotes.contains(item)) {
                          //     favouriteQuotes.remove(item);
                          //   } else {
                          //     favouriteQuotes.add(item);
                          //   }
                          // });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
