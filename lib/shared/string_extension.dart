// to capitalize first letter of each domain/traits
extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get titleCase =>
      split(" ").map((str) => str.inCaps).join(" ");
}