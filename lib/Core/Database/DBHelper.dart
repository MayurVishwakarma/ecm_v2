// ignore_for_file: unused_local_variable, file_names, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'package:ecm_v2/Core/Models/ECMReportModel.dart';
import 'package:ecm_v2/Core/Models/EcmNodeMasterModel.dart';
import 'package:ecm_v2/Core/Models/ProcessMasterModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ECMReportDB {
  static const _databaseName = "ECMReport.db3";
  static const _databaseVersion = 1;
  ECMReportDB._privateConstructor();
  static final ECMReportDB instance = ECMReportDB._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final buffer = StringBuffer();
    buffer.write('CREATE TABLE ${EcmReportMasterModel.tableName} (');

    EcmReportMasterModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${EcmReportMasterModel.tableName} created ✅");
  }

  /// Insert or Update
  Future<bool> insertOrUpdate(EcmReportMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        EcmReportMasterModel.tableName,
        where:
            'deviceId = ? AND processId = ? AND deviceType = ? AND checkListId = ? AND projectId = ?',
        whereArgs: [
          model.deviceId,
          model.processId,
          model.deviceType,
          model.checkListId,
          model.projectId,
        ],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          EcmReportMasterModel.tableName,
          model.toJson(),
          where:
              'checkListId = ? AND deviceId = ? AND processId = ? AND deviceType = ? AND projectId = ?',
          whereArgs: [
            model.checkListId,
            model.deviceId,
            model.processId,
            model.deviceType,
            model.projectId,
          ],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for checkListId=${model.checkListId}, deviceId=${model.deviceId}, processId=${model.processId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmReportMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for checkListId=${model.checkListId}, deviceId=${model.deviceId}, processId=${model.processId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }

  Future<void> deleteECMReport(
    int deviceId,
    int processId,
    String deviceType,
    int projectId,
  ) async {
    final db = await database;
    await db.delete(
      EcmReportMasterModel.tableName,
      where:
          'deviceId = ? AND processId = ? AND deviceType = ? AND projectId = ?',
      whereArgs: [deviceId, processId, deviceType, projectId],
    );
  }

  /// Universal fetch helper
  Future<List<EcmReportMasterModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      EcmReportMasterModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${EcmReportMasterModel.tableName}");
      return [];
    }

    List<EcmReportMasterModel> result = [];
    result.addAll(maps.map((e) => EcmReportMasterModel.fromJson(e)).toList());
    print(
      "Fetched ${result.first.description} records from ${EcmReportMasterModel.tableName}",
    );

    return result;
  }

  /// Examples of usage
  Future<List<EcmReportMasterModel>> fetchAll() => fetchData();

  Future<List<EcmReportMasterModel>> fetchByDevice(
    int deviceId,
    int projectId,
  ) => fetchData(
    where: 'deviceId = ? AND projectId = ?',
    whereArgs: [deviceId, projectId],
  );

  // To fetch by device, process and type
  Future<List<EcmReportMasterModel>> fetchEMCReport(
    int deviceId,
    int processId,
    String deviceType,
    int projectId,
  ) => fetchData(
    where:
        'deviceId = ? AND processId = ? AND deviceType = ? AND projectId = ?',
    whereArgs: [deviceId, processId, deviceType, projectId],
  );

  Future<List<EcmReportMasterModel>> fetchByProcess(
    int processId,
    int deviceId,
    int projectId,
  ) => fetchData(
    where: 'ProcessId = ? AND deviceId = ? AND projectId = ?',
    whereArgs: [processId, deviceId, projectId],
  );

  Future<List<EcmReportMasterModel>> fetchByType(
    int processId,
    String deviceType,
    int projectId,
  ) => fetchData(
    where: 'processId = ? AND deviceType = ? AND projectId = ?',
    whereArgs: [processId, deviceType, projectId],
  );

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

class ProcessDB {
  static const _databaseName = "ECMProcess.db3";
  static const _databaseVersion = 1;
  ProcessDB._privateConstructor();
  static final ProcessDB instance = ProcessDB._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final buffer = StringBuffer();
    buffer.write('CREATE TABLE ${ProcessMasterModel.tableName} (');

    ProcessMasterModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${ProcessMasterModel.tableName} created ✅");
  }

  /*
  Future<int> insert(ProcessMasterModel model) async {
    final db = await database;
    final rowId = await db.insert(
      ProcessMasterModel.tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // 🔥 avoids duplicates
    );
    print(
      'Inserted row $rowId into ${ProcessMasterModel.tableName}: ${model.toJson()}',
    );
    return rowId;
  }

  /// Update
  Future<void> update(ProcessMasterModel value) async {
    final db = await database;
    await db.update(
      ProcessMasterModel.tableName,
      value.toJson(),
      where: 'processId = ? AND deviceType = ?',
      whereArgs: [value.processId, value.deviceType],
    );
  }
*/
  Future<void> insertOrUpdate(ProcessMasterModel model) async {
    final db = await database;

    // 1️⃣ Check if a row exists with the same processId + deviceType
    final existing = await db.query(
      ProcessMasterModel.tableName,
      where: 'processId = ? AND deviceType = ? AND projectId = ?',
      whereArgs: [model.processId, model.deviceType, model.projectId],
    );

    if (existing.isNotEmpty) {
      // 2️⃣ If exists → Update
      await db.update(
        ProcessMasterModel.tableName,
        model.toJson(),
        where: 'processId = ? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.processId, model.deviceType, model.projectId],
      );
      print(
        "🔄 Updated existing row for processId=${model.processId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
      );
    } else {
      // 3️⃣ If not exists → Insert
      final rowId = await db.insert(
        ProcessMasterModel.tableName,
        model.toJson(),
      );
      print(
        "✅ Inserted new row $rowId for processId=${model.processId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
      );
    }
  }

  /// Delete
  Future<void> delete(ProcessMasterModel value) async {
    final db = await database;
    await db.delete(
      ProcessMasterModel.tableName,
      where: 'processId = ? AND projectId = ?',
      whereArgs: [value.processId, value.projectId],
    );
  }

  Future<void> deleteByDeviceType(ProcessMasterModel value) async {
    final db = await database;
    await db.delete(
      ProcessMasterModel.tableName,
      where: 'processId = ? AND deviceType = ? AND projectId = ?',
      whereArgs: [value.processId, value.deviceType, value.projectId],
    );
  }

  /// Universal fetch helper
  Future<List<ProcessMasterModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      ProcessMasterModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${ProcessMasterModel.tableName}");
      return [];
    }
    // maps.forEach((element) {
    //   print("Fetched from $EcmReportMasterModel.tableName: $element");
    // });
    List<ProcessMasterModel> result = [];
    result.addAll(maps.map((e) => ProcessMasterModel.fromJson(e)).toList());
    print(
      "Fetched ${result.first.processName} records from ${ProcessMasterModel.tableName}",
    );

    return result;
  }

  /// Examples of usage
  Future<List<ProcessMasterModel>> fetchAll() => fetchData();

  Future<List<ProcessMasterModel>> fetchByDevice(
    String deviceType,
    int projectId,
  ) => fetchData(
    where: 'deviceType = ? AND projectId = ?',
    whereArgs: [deviceType, projectId],
  );

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

class NodeDB {
  static const _databaseName = "ECMNodes.db3";
  static const _databaseVersion = 1;
  NodeDB._privateConstructor();
  static final NodeDB instance = NodeDB._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final buffer = StringBuffer();
    buffer.write('CREATE TABLE ${EcmNodeListMasterModel.tableName} (');

    EcmNodeListMasterModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${EcmNodeListMasterModel.tableName} created ✅");
  }

  /// Insert or Update OMS Nodes
  Future<bool> insertOrUpdateOms(EcmNodeListMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same omsId + deviceType + projectId
      final existing = await db.query(
        EcmNodeListMasterModel.tableName,
        where: 'OmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.omsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        final existingRow = existing.first;

        // 2️⃣ If existing row has IsSaved=1 → Don't update/insert
        if ((existingRow['IsSaved'] ?? 0) == 1) {
          print(
            "⏩ Skipped update/insert because IsSaved=1 for omsId=${model.omsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true; // you can also return false if you want to mark "no changes made"
        }

        // 3️⃣ Otherwise → Update
        final count = await db.update(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
          where: 'OmsId = ? AND deviceType = ? AND projectId = ?',
          whereArgs: [model.omsId, model.deviceType, model.projectId],
        );

        if (count > 0) {
          print(
            "🔄 Updated existing row for omsId=${model.omsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 4️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for omsId=${model.omsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }

  /*Future<bool> insertOrUpdateOms(EcmNodeListMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        EcmNodeListMasterModel.tableName,
        where: 'OmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.omsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
          where: 'omsId = ?  AND deviceType = ? AND projectId = ?',
          whereArgs: [model.omsId, model.deviceType, model.projectId],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for  omsId=${model.omsId}, deviceType=${model.deviceType} , projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for omsId=${model.omsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }
*/
  /// Insert or Update AMS Nodes
  Future<bool> insertOrUpdateAms(EcmNodeListMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        EcmNodeListMasterModel.tableName,
        where: 'AmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.amsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
          where: 'AmsId = ?  AND deviceType = ? AND projectId = ?',
          whereArgs: [model.amsId, model.deviceType, model.projectId],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for  AmsId=${model.amsId}, deviceType=${model.deviceType} , projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for AmsId=${model.amsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }

  /// Insert or Update RMS Nodes
  Future<bool> insertOrUpdateRms(EcmNodeListMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        EcmNodeListMasterModel.tableName,
        where: 'RmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.rmsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
          where: 'RmsId = ?  AND deviceType = ? AND projectId = ?',
          whereArgs: [model.rmsId, model.deviceType, model.projectId],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for  RmsId=${model.rmsId}, deviceType=${model.deviceType} , projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for RmsId=${model.rmsId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }

  /// Insert or Update LoRa Nodes
  Future<bool> insertOrUpdateLoRa(EcmNodeListMasterModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        EcmNodeListMasterModel.tableName,
        where: 'GateWayId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.gateWayId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
          where: 'GateWayId = ?  AND deviceType = ? AND projectId = ?',
          whereArgs: [model.gateWayId, model.deviceType, model.projectId],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for  GateWayId=${model.gateWayId}, deviceType=${model.deviceType} , projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          EcmNodeListMasterModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for GateWayId=${model.gateWayId}, deviceType=${model.deviceType}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row: $e");
      return false;
    }
  }

  /// Universal fetch helper
  Future<List<EcmNodeListMasterModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      EcmNodeListMasterModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${EcmNodeListMasterModel.tableName}");
      return [];
    }

    List<EcmNodeListMasterModel> result = [];
    result.addAll(maps.map((e) => EcmNodeListMasterModel.fromJson(e)).toList());
    print(
      "Fetched ${result.length} records from ${EcmNodeListMasterModel.tableName}",
    );

    return result;
  }

  /// Examples of usage
  Future<List<EcmNodeListMasterModel>> fetchAll() => fetchData();

  /// Fetch nodes by device type and projectId
  Future<List<EcmNodeListMasterModel>> fetchNodeByDeviceType(
    String deviceType,
    int projectId,
  ) => fetchData(
    where: 'deviceType = ? AND projectId = ?',
    whereArgs: [deviceType, projectId],
  );

  /// Delete node by omsId , deviceType and projectId
  Future<void> deleteOMSNode(
    int omsId,
    int projectId,
    String deviceType,
  ) async {
    final db = await database;
    await db.delete(
      EcmNodeListMasterModel.tableName,
      where: 'OmsId = ? AND projectId = ? AND deviceType = ?',
      whereArgs: [omsId, projectId, deviceType],
    );
  }

  Future<void> deleteAMSNode(
    int amsId,
    int projectId,
    String deviceType,
  ) async {
    final db = await database;
    await db.delete(
      EcmNodeListMasterModel.tableName,
      where: 'AmsId = ? AND projectId = ? AND deviceType = ?',
      whereArgs: [amsId, projectId, deviceType],
    );
  }

  Future<void> deleteRMSNode(
    int rmsId,
    int projectId,
    String deviceType,
  ) async {
    final db = await database;
    await db.delete(
      EcmNodeListMasterModel.tableName,
      where: 'RmsId = ? AND projectId = ? AND deviceType = ?',
      whereArgs: [rmsId, projectId, deviceType],
    );
  }

  Future<void> deleteLoRANode(
    int gatewayId,
    int projectId,
    String deviceType,
  ) async {
    final db = await database;
    await db.delete(
      EcmNodeListMasterModel.tableName,
      where: 'GateWayId = ? AND projectId = ? AND deviceType = ?',
      whereArgs: [gatewayId, projectId, deviceType],
    );
  }

  Future<void> deleteNode() async {
    final db = await database;
    await db.delete(EcmNodeListMasterModel.tableName);
  }


}
