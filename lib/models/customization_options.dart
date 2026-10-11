class CuttingOption {
  final String id;
  final String name;
  final String icon;

  const CuttingOption(
      {required this.id, required this.name, required this.icon});
}

class PackagingOption {
  final String id;
  final String name;
  final String desc;

  const PackagingOption(
      {required this.id, required this.name, required this.desc});
}

class WeightPreset {
  final String label;
  final String short;
  final double multiplier;

  const WeightPreset(
      {required this.label, required this.short, required this.multiplier});
}

class CarcassOption {
  final String id;
  final String name;

  const CarcassOption({required this.id, required this.name});
}
