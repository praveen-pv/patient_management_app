class SelectedTreatment {
  final int id;
  final String name;
  int male;
  int female;

  SelectedTreatment({
    required this.id,
    required this.name,
    this.male = 0,
    this.female = 0,
  });
}
