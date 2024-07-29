
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_exchange.dart';
import 'package:AthaPyar/datatbase/model/tbl_gold.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ExchangeService{
   static var uuid=Uuid();
   static Future<List<TBLGold>> selectGoldList(String date)async{
      final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
      var list=await database.tblGoldDao.selectByDate(date);
      return list;
   }

   static Future<List<TBLGold>> selectYesterdayGoldList(String date)async{

      final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
      var list=await database.tblGoldDao.selectByDate(date);
      return list;
   }
   static Future<List<TBLExchange>> selectExchangeList(String date,)async{
      SharedPreferences pref=await SharedPreferences.getInstance();
      String code=myanmarCode;
      if(pref.getString(selected_country)!=null){
         code=await pref.getString(selected_country).toString();
      }
      Map? map=await RequestResponseApi.getExchangeRate(date,code);
      var profileId=pref.getString(mProfileId).toString();

      final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
      var mList=await database.tblExchangeDao.selectByDate(date,code);
      if(mList==null || mList.isEmpty){
         if(map!=null && map.length>0){
            ('ExchangeList map: ${map.length}');

            map.forEach((key, value)async {
               var id=uuid.v1();
               var tblExchangeRate=TBLExchange(id: id, name: key, price: value.toString(), createdAt: date, createdBy: code, updatedAt: date, updatedBy: profileId);
               await database.tblExchangeDao.insert(tblExchangeRate);
            });
         }
      }
      print('ExchangeList map: ${map}');
      print('ExchangeList date: ${date}');

      var exchangeList=await database.tblExchangeDao.selectByDate(date,code);
      print('ExchangeList result: ${exchangeList.length}');
      return exchangeList;
   }
}