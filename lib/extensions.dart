extension DateFormatter on DateTime {
  String formatDate() {
    final List<String> months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];

    return '${day} ${months[month - 1]} $year';
  }
}