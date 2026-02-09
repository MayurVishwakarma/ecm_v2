// ignore_for_file: avoid_print

import '../../../Core/Models/Damage/DamageNodeMasterModel.dart';
import '../../../Core/Models/Damage/DamageReportModel.dart';
import '../../../Core/Models/Damage/MaterialReportModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DamageNodeDB {
  static const _databaseName = "DamageNodes.db3";
  static const _databaseVersion = 1;
  DamageNodeDB._privateConstructor();
  static final DamageNodeDB instance = DamageNodeDB._privateConstructor();
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
    buffer.write('CREATE TABLE ${DamageNodeModel.tableName} (');

    DamageNodeModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${DamageNodeModel.tableName} created ✅");
  }

  /// Insert or Update OMS Nodes
  Future<bool> insertOrUpdateOms(DamageNodeModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same omsId + deviceType + projectId
      final existing = await db.query(
        DamageNodeModel.tableName,
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
          DamageNodeModel.tableName,
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
          DamageNodeModel.tableName,
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

  /// Insert or Update AMS Nodes
  Future<bool> insertOrUpdateAms(DamageNodeModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        DamageNodeModel.tableName,
        where: 'AmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.amsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          DamageNodeModel.tableName,
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
          DamageNodeModel.tableName,
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
  Future<bool> insertOrUpdateRms(DamageNodeModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        DamageNodeModel.tableName,
        where: 'RmsId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.rmsId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          DamageNodeModel.tableName,
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
          DamageNodeModel.tableName,
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
  Future<bool> insertOrUpdateLoRa(DamageNodeModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        DamageNodeModel.tableName,
        where: 'GateWayId=? AND deviceType = ? AND projectId = ?',
        whereArgs: [model.gateWayId, model.deviceType, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          DamageNodeModel.tableName,
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
          DamageNodeModel.tableName,
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
  Future<List<DamageNodeModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      DamageNodeModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${DamageNodeModel.tableName}");
      return [];
    }

    List<DamageNodeModel> result = [];
    result.addAll(maps.map((e) => DamageNodeModel.fromJson(e)).toList());
    print("Fetched ${result.length} records from ${DamageNodeModel.tableName}");

    return result;
  }

  /// Examples of usage
  Future<List<DamageNodeModel>> fetchAll() => fetchData();

  /// Fetch nodes by device type and projectId
  Future<List<DamageNodeModel>> fetchNodeByDeviceType(
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
      DamageNodeModel.tableName,
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
      DamageNodeModel.tableName,
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
      DamageNodeModel.tableName,
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
      DamageNodeModel.tableName,
      where: 'GateWayId = ? AND projectId = ? AND deviceType = ?',
      whereArgs: [gatewayId, projectId, deviceType],
    );
  }

  Future<void> deleteNode() async {
    final db = await database;
    await db.delete(DamageNodeModel.tableName);
  }
}

class DamageReportDB {
  static const _databaseName = "DamageReport.db3";
  static const _databaseVersion = 1;
  DamageReportDB._privateConstructor();
  static final DamageReportDB instance = DamageReportDB._privateConstructor();
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
    buffer.write('CREATE TABLE ${DamageReportModel.tableName} (');

    DamageReportModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${DamageReportModel.tableName} created ✅");
  }

  /// Insert or Update
  Future<bool> insertOrUpdate(
    DamageReportModel model,
    String deviceType,
  ) async {
    try {
      final db = await database;

      // Pick the right column based on deviceType
      String columnName;
      int? columnValue;

      switch (deviceType.toLowerCase()) {
        case "oms":
          columnName = "OmsId";
          columnValue = model.omsId;
          break;
        case "ams":
          columnName = "AmsId";
          columnValue = model.amsid;
          break;
        case "rms":
          columnName = "RmsId";
          columnValue = model.rmsid;
          break;
        case "lora":
          columnName = "GatewayId";
          columnValue = model.gateWayId;
          break;
        default:
          throw Exception("❌ Unknown deviceType: $deviceType");
      }

      // 1️⃣ Check if row exists
      final existing = await db.query(
        DamageReportModel.tableName,
        where: '$columnName = ? AND Id = ? AND projectId = ?',
        whereArgs: [columnValue, model.id, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ Update if exists
        final count = await db.update(
          DamageReportModel.tableName,
          model.toJson(),
          where: 'Id = ? AND $columnName = ? AND projectId = ?',
          whereArgs: [model.id, columnValue, model.projectId],
        );

        if (count > 0) {
          print(
            "🔄 Updated row for deviceType=$deviceType, $columnName=$columnValue, Id=${model.id}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ Insert if not exists
        final rowId = await db.insert(
          DamageReportModel.tableName,
          model.toJson(),
        );

        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for deviceType=$deviceType, $columnName=$columnValue, Id=${model.id}, projectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("❌ Error inserting/updating row for deviceType=$deviceType: $e");
      return false;
    }
  }

  Future<void> deleteDamageReport(
    int deviceId,
    int projectId,
    String deviceType,
  ) async {
    // Pick the right column based on deviceType
    String columnName;

    switch (deviceType.toLowerCase()) {
      case "oms":
        columnName = "OmsId";

        break;
      case "ams":
        columnName = "AmsId";

        break;
      case "rms":
        columnName = "RmsId";

        break;
      case "lora":
        columnName = "GatewayId";

        break;
      default:
        throw Exception("❌ Unknown deviceType: $deviceType");
    }

    final db = await database;
    await db.delete(
      DamageReportModel.tableName,
      where: '$columnName = ? AND projectId = ?',
      whereArgs: [deviceId, projectId],
    );
  }

  /// Universal fetch helper
  Future<List<DamageReportModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      DamageReportModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${DamageReportModel.tableName}");
      return [];
    }

    List<DamageReportModel> result = [];
    result.addAll(maps.map((e) => DamageReportModel.fromJson(e)).toList());
    print(
      "Fetched ${result.first.damage} records from ${DamageReportModel.tableName}",
    );

    return result;
  }

  /// Examples of usage
  Future<List<DamageReportModel>> fetchAll() => fetchData();

  // Future<List<DamageReportModel>> fetchByDevice(int deviceId, int projectId) =>
  //     fetchData(
  //       where: 'OmsId = ? AND projectId = ?',
  //       whereArgs: [deviceId, projectId],
  //     );

  // To fetch by device, process and type
  Future<List<DamageReportModel>> fetchDamageReport(
    int deviceId,
    String deviceType,
    int projectId,
  ) {
    // Pick the right column based on deviceType
    String columnName;

    switch (deviceType.toLowerCase()) {
      case "oms":
        columnName = "OmsId";

        break;
      case "ams":
        columnName = "AmsId";

        break;
      case "rms":
        columnName = "RmsId";

        break;
      case "lora":
        columnName = "GatewayId";

        break;
      default:
        throw Exception("❌ Unknown deviceType: $deviceType");
    }

    return fetchData(
      where: '$columnName = ? AND projectId = ?',
      whereArgs: [deviceId, projectId],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

class MaterialReportDB {
  static const _databaseName = "MaterialReport.db3";
  static const _databaseVersion = 1;
  MaterialReportDB._privateConstructor();
  static final MaterialReportDB instance =
      MaterialReportDB._privateConstructor();
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
    buffer.write('CREATE TABLE ${MaterialReportModel.tableName} (');

    MaterialReportModel.schema.forEach((col, type) {
      buffer.write('$col $type,');
    });

    // remove last comma
    final sql = buffer.toString().replaceFirst(RegExp(r',$'), '');
    buffer.clear();
    buffer.write('$sql);');

    await db.execute(buffer.toString());
    print("Table ${MaterialReportModel.tableName} created ✅");
  }

  /// Insert or Update
  Future<bool> insertOrUpdate(MaterialReportModel model) async {
    try {
      final db = await database;

      // 1️⃣ Check if a row exists with the same processId + deviceType
      final existing = await db.query(
        MaterialReportModel.tableName,
        where: 'DeviceId = ?  AND Id = ? AND ProjectId = ?',
        whereArgs: [model.deviceId, model.id, model.projectId],
      );

      if (existing.isNotEmpty) {
        // 2️⃣ If exists → Update
        final count = await db.update(
          MaterialReportModel.tableName,
          model.toJson(),
          where: 'Id = ? AND DeviceId = ? AND ProjectId = ?',
          whereArgs: [model.id, model.deviceId, model.projectId],
        );
        if (count > 0) {
          print(
            "🔄 Updated existing row for Id=${model.id}, DeviceId=${model.deviceId}, ProjectId=${model.projectId}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // 3️⃣ If not exists → Insert
        final rowId = await db.insert(
          MaterialReportModel.tableName,
          model.toJson(),
        );
        if (rowId > 0) {
          print(
            "✅ Inserted new row $rowId for Id=${model.id}, DeviceId=${model.deviceId}, ProjectId=${model.projectId}",
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

  Future<void> deleteRectificationReport(int deviceId, int projectId) async {
    final db = await database;
    await db.delete(
      MaterialReportModel.tableName,
      where: 'DeviceId = ? AND projectId = ?',
      whereArgs: [deviceId, projectId],
    );
  }

  /// Universal fetch helper
  Future<List<MaterialReportModel>> fetchData({
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final maps = await db.query(
      MaterialReportModel.tableName,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isEmpty) {
      print("No data found in ${MaterialReportModel.tableName}");
      return [];
    }

    List<MaterialReportModel> result = [];
    result.addAll(maps.map((e) => MaterialReportModel.fromJson(e)).toList());
    print(
      "Fetched ${result.first.rectification} records from ${MaterialReportModel.tableName}",
    );

    return result;
  }

  /// Examples of usage
  Future<List<MaterialReportModel>> fetchAll() => fetchData();

  Future<List<MaterialReportModel>> fetchByDevice(
    int deviceId,
    int projectId,
  ) => fetchData(
    where: 'DeviceId = ? AND ProjectId = ?',
    whereArgs: [deviceId, projectId],
  );

  // To fetch by device, process and type
  Future<List<MaterialReportModel>> fetchRectificationReport(
    int deviceId,
    String deviceType,
    int projectId,
  ) => fetchData(
    where: 'DeviceId = ? AND ProjectId = ?',
    whereArgs: [deviceId, projectId],
  );

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
