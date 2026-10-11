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
  Country(code: 'SA', name: 'المملكة العربية السعودية', dial: '+966', placeholder: '50 123 4567'),
  Country(code: 'AE', name: 'الإمارات العربية المتحدة', dial: '+971', placeholder: '50 123 4567'),
  Country(code: 'KW', name: 'الكويت', dial: '+965', placeholder: '50 123 456'),
  Country(code: 'QA', name: 'قطر', dial: '+974', placeholder: '33 123 456'),
  Country(code: 'BH', name: 'البحرين', dial: '+973', placeholder: '36 123 456'),
  Country(code: 'OM', name: 'سلطنة عمان', dial: '+968', placeholder: '91 123 456'),
  Country(code: 'EG', name: 'جمهورية مصر العربية', dial: '+20', placeholder: '010 1234 5678'),
  Country(code: 'JO', name: 'المملكة الأردنية الهاشمية', dial: '+962', placeholder: '79 123 4567'),
];
