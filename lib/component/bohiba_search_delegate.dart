import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BohibaSearchDelegate<T> extends SearchDelegate<T?> {
  final List<T> items;
  final bool Function(T item, String query) searchPredicate;
  final Widget Function(BuildContext context, T item) itemBuilder;

  BohibaSearchDelegate({
    required this.items,
    required this.searchPredicate,
    required this.itemBuilder,
    String hintText = "Search...",
  }) : super(
          searchFieldLabel: hintText,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        color: bohibaTheme.iconTheme.color,
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: bohibaTheme.iconTheme.color,
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        items.where((item) => searchPredicate(item, query)).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No results found"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => itemBuilder(context, results[index]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        items.where((item) => searchPredicate(item, query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => itemBuilder(context, suggestions[index]),
    );
  }
}

class BohibaCompanySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        color: BohibaColors.primaryColor,
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      color: BohibaColors.primaryColor,
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Search results for: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 14,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Result ${index + 1}'),
          onTap: () {
            query = '$index';
            showResults(context);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return bohibaTheme.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.zero,
        fillColor: bohibaTheme.appBarTheme.backgroundColor,
        hintStyle: bohibaTheme.textTheme.titleMedium,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CustomLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(const CustomLocalization());
  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;
  @override
  String toString() => 'CustomLocalization.delegate(en_US)';
}

class CustomLocalization extends DefaultMaterialLocalizations {
  const CustomLocalization();
  @override
  String get searchFieldLabel => "Search by company name";
}
