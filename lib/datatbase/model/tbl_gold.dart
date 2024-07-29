import 'package:floor/floor.dart';

@entity
class TBLGold{
  @primaryKey
  final String id;
  final String local_price;
  final String date;
  TBLGold({required this.id,required this.local_price,required this.date});

  factory TBLGold.fromJson(Map<String,dynamic> jsonData){
    return TBLGold(id: jsonData['id'], local_price: jsonData['local_price'], date: jsonData['date']);
  }
}
