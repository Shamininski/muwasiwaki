class Subregions {
  static const List<String> all = [
    'Kibosho',
    'Hai',
    'Same',
    'Marangu',
    'Old Moshi',
    'Rombo',
    'Mwanga',
  ];

  static bool isValid(String subregion) {
    return all.contains(subregion);
  }
}
