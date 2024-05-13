import 'package:mongo_dart/mongo_dart.dart';

class Repository {

  static final _db = Db("mongodb://jolaoshobatmat:D8VZuUJJdkpaOKtL@ac-h0nunxt-shard-00-00.lhuprwz.mongodb.net:27017,ac-h0nunxt-shard-00-01.lhuprwz.mongodb.net:27017,ac-h0nunxt-shard-00-02.lhuprwz.mongodb.net:27017/?ssl=true&replicaSet=atlas-xu2bh8-shard-0&authSource=admin&retryWrites=true&w=majority&appName=cluster-1");

  static Future<Db> db() async {
    if( !_db.isConnected ) await _db.open();

    return _db;
  }

  static Future<DbCollection> artifacts() async {
    return (await db()).collection('artifacts');
  }

  static Future<DbCollection> users() async {
    return (await db()).collection('users');
  }

}