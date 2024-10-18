import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bohiba_colors.dart';

class BohibaCompanySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        color: bohibaColors.primaryColor,
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
      color: bohibaColors.primaryColor,
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform search and display search results
    return Text('Search results for: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Display suggestions as the user types in the search field
    return ListView.builder(
      itemCount: 14,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Company ${index + 1}'),
          onTap: () {
            query = 'Company $index';
            showResults(context);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0.5, // Change the elevation value here
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.zero,
        fillColor: bohibaColors.white,
        hintStyle: Theme.of(context).textTheme.titleMedium,
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
