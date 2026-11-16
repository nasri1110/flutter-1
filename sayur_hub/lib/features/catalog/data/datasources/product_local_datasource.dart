import 'package:sayur_hub/core/database/database_helper.dart';
import 'package:sayur_hub/features/catalog/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

/// Kontrak sumber data lokal perangkat (Local Data Source Interface)
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts({String? category, String? search});
  Future<void> cacheProducts(List<ProductModel> products);
}

/// Implementasi sumber data lokal menggunakan SQLite (sqflite)
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProductLocalDataSourceImpl({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  static const String tableCache = 'products_cache';

  Future<void> _ensureTableCreated(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCache (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price_per_kg REAL NOT NULL,
        stock INTEGER NOT NULL,
        rating REAL NOT NULL,
        is_organic INTEGER NOT NULL,
        image_url TEXT,
        description TEXT
      )
    ''');
  }

  @override
  Future<List<ProductModel>> getCachedProducts({String? category, String? search}) async {
    final db = await _dbHelper.database;
    await _ensureTableCreated(db);

    String? whereClause;
    List<dynamic>? whereArgs;

    if (category != null && category.isNotEmpty && category != 'Semua') {
      whereClause = 'category = ?';
      whereArgs = [category];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableCache,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return maps.map((row) => ProductModel.fromJson(row)).toList();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await _dbHelper.database;
    await _ensureTableCreated(db);

    final batch = db.batch();
    for (final product in products) {
      batch.insert(
        tableCache,
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
