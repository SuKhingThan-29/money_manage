import 'package:AthaPyar/datatbase/model/tbl_account.dart';

class Accounts{
  final String id;
  final String name;
  final String total;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  List<TBLAccount> accountList;
  Accounts(this.id,this.name,this.total,this.createdAt,this.createdBy,this.updatedAt,this.updatedBy,this.accountList);

}