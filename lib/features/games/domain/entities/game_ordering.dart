enum GameOrdering {
  popularity(label: 'Popularity', value: '-added'), // Default
  releaseDate(label: 'Release Date', value: '-released'),
  rating(label: 'Highest Rated', value: '-rating'),
  dateAdded(label: 'Date Added', value: '-created'),
  name(label: 'Name', value: 'name');

  final String label;
  final String value;
  const GameOrdering({required this.label, required this.value});
}