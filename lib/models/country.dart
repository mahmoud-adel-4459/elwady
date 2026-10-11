class Country {
  final String code;
  final String name;
  final String dial;
  final String placeholder;

  const Country({
    required this.code,
    required this.name,
    required this.dial,
    required this.placeholder,
  });
}

const List<Country> kArabCountries = [
  Country(
      code: 'SA',
      name: 'المملكة العربية السعودية',
      dial: '+966',
      placeholder: '5X XXX XXXX'),
  Country(
      code: 'AE',
      name: 'الإمارات العربية المتحدة',
      dial: '+971',
      placeholder: '5X XXX XXXX'),
  Country(code: 'KW', name: 'الكويت', dial: '+965', placeholder: '9X XXX XXX'),
  Country(code: 'QA', name: 'قطر', dial: '+974', placeholder: '5X XXX XXX'),
  Country(code: 'BH', name: 'البحرين', dial: '+973', placeholder: '3X XXX XXX'),
  Country(
      code: 'OM', name: 'سلطنة عمان', dial: '+968', placeholder: '9X XXX XXX'),
  Country(code: 'EG', name: 'مصر', dial: '+20', placeholder: '1X XXXX XXXX'),
  Country(code: 'JO', name: 'الأردن', dial: '+962', placeholder: '7X XXX XXXX'),
];
