class LanguageChange {
  final String id;
  final String image;
  final String code;
  final String country;

  LanguageChange(
      {required this.id, required this.image, required this.code,required this.country});

   static List<LanguageChange> items =[
    LanguageChange(
    id: "mya-d320a502-5371-4707-927f-d53ca36b972f0",
    image:
    'assets/settings/lang/myanmar.png',
    code:'+95',
    country: 'Myanmar',

  ),
    LanguageChange(
      id: "cambodia-d320a502-5371-4707-927f-d53ca36b972f1",
      country: 'Cambodia',
      code:'+855',
      image:
      'assets/settings/lang/cambodia.png',
    )
  ];

}
