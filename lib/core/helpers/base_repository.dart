
import 'package:ceinture/core/helpers/base_entity.dart';
import 'package:ceinture/core/helpers/database_helper.dart';

abstract class BaseRepository<T extends BaseEntity, PK> {
  String _tableName;

  BaseRepository(this._tableName) {}

  T getEntity();

  Future<int> save(T t) async {
    try {
      var dbClient = await DatabaseHelper.database;
      print('$_tableName ============== ${t.toDatabase()}');
      int res = await dbClient.insert("$_tableName", t.toDatabase());
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<bool> update(T t, PK k) async {
    var dbClient = await DatabaseHelper.database;
    int res = await dbClient.update(_tableName, t.toDatabase(),
        where: "id = ?", whereArgs: <PK>[k]);
    return res > 0 ? true : false;
  }

  Future<List<T>> getAll() async {
    var dbClient = await DatabaseHelper.database;
    var res = await dbClient.rawQuery('SELECT * FROM $_tableName');

    return List.generate(res.length, (i) {
      return getEntity().fromDatabase(res[i]);
    });
  }


  Future<List<T>> all() async {
    var dbClient = await DatabaseHelper.database;
    final sql = '''SELECT * FROM $_tableName''';
    final data = await dbClient.rawQuery(sql);

    return List.generate(data.length, (i) {
      return getEntity().fromDatabase(data[i]);
    });
  }

  Future<List<T>> list() async {
    var dbClient = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await dbClient.query(' $_tableName');
    List<T> lis = List.generate(maps.length, (i) {
      return getEntity().fromDatabase(maps[i]);
    });
    return lis;
  }

  Future<int> delete(PK k) async {
    var dbClient = await DatabaseHelper.database;
    int res =
        await dbClient.rawDelete('DELETE FROM $_tableName WHERE id = ?', [k]);
    return res;
  }

  Future<int> count() async {
    var dbClient = await DatabaseHelper.database;
    final data =
        await dbClient.rawQuery('''SELECT COUNT(*) FROM $_tableName''');
    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
