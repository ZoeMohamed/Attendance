import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String movimentacaoTABLE = "movimentacaoTABLE";
final String idColumn = "idColumn";
final String dataColumn = "dataColumn";
final String valorColumn = "valorColumn";
final String tipoColumn = "tipoColumn";
final String descricaoColumn = "descricaoColumn";
final String projectTitleColumn = "projectTitleColumn";
final String buktiColumn = "buktiColumn";
final String idParentColumn = "idParentColumn";
final String userIDColumn = "userIdColumn";
final String teamIDColumn = "teamIdColumn";
final String nameUserColumn = "nameUserColumn";
final String saldoAwalColumn = "saldoAwalColumn";
final String statusColumn = "statusColumn";
final String uniqTimeColumn = "uniqTimeColumn";

class MovimentacoesHelper {
  static final MovimentacoesHelper _instance = MovimentacoesHelper.internal();

  factory MovimentacoesHelper() => _instance;

  MovimentacoesHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    print("Init DB");
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "movimentacao.db");
    print("PATHNYA DB " + path);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $movimentacaoTABLE(" +
          "$idColumn INTEGER PRIMARY KEY," +
          "$valorColumn FLOAT," +
          "$dataColumn TEXT," +
          "$tipoColumn TEXT," +
          "$descricaoColumn TEXT," +
          "$projectTitleColumn TEXT," +
          "$buktiColumn TEXT," +
          "$idParentColumn INTEGER," +
          "$userIDColumn INTEGER," +
          "$teamIDColumn INTEGER," +
          "$nameUserColumn TEXT," +
          "$saldoAwalColumn FLOAT," +
          "$statusColumn INTEGER," +
          "$uniqTimeColumn TEXT)");
    });
  }

  Future<Movimentacoes> saveMovimentacao(Movimentacoes movimentacoes) async {
    log("--------------- chamada save --------");

    Database dbMovimentacoes = await db;
    movimentacoes.id = await dbMovimentacoes.insert(
        movimentacaoTABLE, movimentacoes.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(movimentacoes);
    log("--------------- chamada save --------");
    return movimentacoes;
  }

  Future<Movimentacoes> getMovimentacoes(int id) async {
    Database dbMovimentacoes = await db;
    List<Map> maps = await dbMovimentacoes.query(movimentacaoTABLE,
        columns: [
          idColumn,
          valorColumn,
          dataColumn,
          tipoColumn,
          descricaoColumn,
          projectTitleColumn,
          buktiColumn,
          idParentColumn,
          userIDColumn,
          teamIDColumn,
          nameUserColumn,
          saldoAwalColumn,
          statusColumn,
          uniqTimeColumn,
        ],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Movimentacoes.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovimentacao(Movimentacoes movimentacoes) async {
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.delete(movimentacaoTABLE,
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<int> updateMovimentacao(Movimentacoes movimentacoes) async {
    // log("--------------chamada update------------- (1)");
    // log(movimentacaoTABLE);
    // log(movimentacoes.toMap().toString());
    // log("----------chamada update----------------- (2)");
    log(movimentacoes.toString());
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.update(
        movimentacaoTABLE, movimentacoes.toMap(),
        where: "$idColumn = ?", whereArgs: [movimentacoes.id]);
  }

  Future<List> getAllMovimentacoes() async {
    Database dbMovimentacoes = await db;
    List listMap =
        await dbMovimentacoes.rawQuery("SELECT * FROM $movimentacaoTABLE");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorMes(String data, String team_id) async {
    Database dbMovimentacoes = await db;

    print("DATA USERID DARI MODEL HELPER " + team_id);
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $teamIDColumn = " +
            team_id +
            " AND $idParentColumn = 0 AND $dataColumn LIKE '%$data%' ORDER BY $idColumn DESC");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getTotalBudgetAwal(String data, String team_id) async {
    Database dbMovimentacoes = await db;

    print("DATA USERID DARI MODEL HELPER " + team_id);
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $teamIDColumn = " +
            team_id +
            " AND $dataColumn LIKE '%$data%'");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorMesLEX(String data, String team_id) async {
    print("INI DI HELPER NYA " + data);
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $teamIDColumn = " +
            team_id +
            " AND $idParentColumn = 0 AND  $dataColumn LIKE '%$data%' ORDER BY $idColumn DESC ");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorTipo(String tipo) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $tipoColumn ='$tipo' ");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getDetailBudget(String id, String query) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery(query);
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    log("tes broo");
    log(id);
    log(idParentColumn);
    log("tes broo");

    return listMovimentacoes;
  }

  Future<double> getDetailBudgetAwal(int id) async {
    Database dbMovimentacoes = await db;
    var datanya = await dbMovimentacoes.rawQuery(
        "SELECT SUM($valorColumn) as Total FROM $movimentacaoTABLE WHERE $idColumn = '$id' OR  $idParentColumn ='$id' ");

    //print("DATANYA DARI HELPER MODEL " + datanya[0]["Total"].toString());
    return datanya[0]["Total"];
  }

  Future<double> getDetailBudgetCount(int id) async {
    Database dbMovimentacoes = await db;
    var datanya = await dbMovimentacoes.rawQuery(
        "SELECT SUM($valorColumn) as Total FROM $movimentacaoTABLE WHERE $idColumn = '$id'");

    //print("DATANYA DARI HELPER MODEL " + datanya[0]["Total"].toString());
    return datanya[0]["Total"];
  }

  Future<int> getNumber() async {
    Database dbMovimentacoes = await db;
    return Sqflite.firstIntValue(await dbMovimentacoes
        .rawQuery("SELECT COUNT(*) FROM $movimentacaoTABLE"));
  }

  Future close() async {
    Database dbMovimentacoes = await db;
    dbMovimentacoes.close();
  }
}

class Movimentacoes {
  int id;
  String data;
  double valor;
  String tipo;
  String descricao;
  String titleproject;
  String buktifoto;
  int idparent;
  int userID;
  int teamID;
  String nameUser;
  double saldoAwal;
  int status;
  String uniqTime;
  Movimentacoes();

  Movimentacoes.fromMap(Map map) {
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
    titleproject = map[projectTitleColumn];
    buktifoto = map[buktiColumn];
    idparent = map[idParentColumn];
    userID = map[userIDColumn];
    teamID = map[teamIDColumn];
    nameUser = map[nameUserColumn];
    saldoAwal = map[saldoAwalColumn];
    status = map[statusColumn];
    uniqTime = map[uniqTimeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      valorColumn: valor,
      dataColumn: data,
      tipoColumn: tipo,
      descricaoColumn: descricao,
      projectTitleColumn: titleproject,
      buktiColumn: buktifoto,
      idParentColumn: idparent,
      userIDColumn: userID,
      teamIDColumn: teamID,
      nameUserColumn: nameUser,
      saldoAwalColumn: saldoAwal,
      statusColumn: status,
      uniqTimeColumn: uniqTime
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  String toString() {
    return "Movimentaoes(id: $id, valor: $valor, data: $data, tipo: $tipo, desc: $descricao, titleproject: $titleproject, buktifoto: $buktifoto, idparent: $idparent, userID: $userID, teamID: $teamID, nameUser: $nameUser, saldoAwal: $saldoAwal, status: $status, uniqTime: $uniqTime)";
  }
}
