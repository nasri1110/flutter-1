import 'package:path/path.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sqflite/sqflite.dart';

/// Database Helper resmi aplikasi SayurHub menggunakan arsitektur SQLite (sqflite).
/// Menerapkan pola Singleton untuk menjamin hanya satu koneksi database terbuka di seluruh aplikasi.
class DatabaseHelper {
  // 1. Instansiasi Singleton Terpadu
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Konstanta Nama Database dan Tabel
  static const String _dbName = 'sayurhub_local.db';
  static const int _dbVersion = 1;

  static const String tableCart = 'cart_items';
  static const String tableFavorites = 'favorites';

  /// Getter database yang menginisialisasi koneksi secara lazy (asinkron)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  /// Inisialisasi berkas basis data pada direktori sandboxed perangkat
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  /// Pembuatan skema tabel awal (DDL)
  Future<void> _createDB(Database db, int version) async {
    // 1. Tabel Item Keranjang Belanja
    await db.execute('''
      CREATE TABLE $tableCart (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price_per_kg REAL NOT NULL,
        stock INTEGER NOT NULL,
        rating REAL NOT NULL,
        is_organic INTEGER NOT NULL,
        image_url TEXT,
        description TEXT,
        quantity REAL NOT NULL,
        customer_notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Tabel Produk Favorit (Wishlist)
    await db.execute('''
      CREATE TABLE $tableFavorites (
        product_id TEXT PRIMARY KEY,
        added_at TEXT NOT NULL
      )
    ''');
  }

  /// Penanganan migrasi struktur tabel jika versi basis data ditingkatkan
  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Skema migrasi untuk rilis masa depan
    }
  }

  // ===========================================================================
  // OPERASI CRUD: KERANJANG BELANJA (CART)
  // ===========================================================================

  /// Menyimpan atau memperbarui item belanjaan ke SQLite
  Future<void> insertOrUpdateCartItem(CartItem item) async {
    final db = await instance.database;

    final Map<String, dynamic> row = {
      'id': item.product.id,
      'name': item.product.name,
      'category': item.product.category,
      'price_per_kg': item.product.pricePerKg,
      'stock': item.product.stock,
      'rating': item.product.rating,
      'is_organic': item.product.isOrganic ? 1 : 0,
      'image_url': item.product.imageUrl,
      'description': item.product.description,
      'quantity': item.quantity,
      'customer_notes': item.customerNotes,
      'created_at': DateTime.now().toIso8601String(),
    };

    await db.insert(
      tableCart,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Mengambil seluruh item belanja yang tersimpan di SQLite secara urut
  Future<List<CartItem>> getAllCartItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCart,
      orderBy: 'created_at ASC',
    );

    if (maps.isEmpty) return [];

    return maps.map((row) {
      final Product product = Product(
        id: row['id'] as String,
        name: row['name'] as String,
        category: row['category'] as String,
        pricePerKg: (row['price_per_kg'] as num).toDouble(),
        stock: row['stock'] as int,
        rating: (row['rating'] as num).toDouble(),
        isOrganic: (row['is_organic'] as int) == 1,
        imageUrl: row['image_url'] as String?,
        description: row['description'] as String?,
      );

      return CartItem(
        product: product,
        quantity: (row['quantity'] as num).toDouble(),
        customerNotes: row['customer_notes'] as String?,
      );
    }).toList();
  }

  /// Memperbarui kuantitas spesifik pada sebuah item di SQLite
  Future<void> updateCartItemQuantity(String productId, double quantity) async {
    final db = await instance.database;
    await db.update(
      tableCart,
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  /// Menghapus satu item dari tabel keranjang
  Future<void> deleteCartItem(String productId) async {
    final db = await instance.database;
    await db.delete(
      tableCart,
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  /// Mengosongkan seluruh tabel keranjang belanja
  Future<void> clearAllCartItems() async {
    final db = await instance.database;
    await db.delete(tableCart);
  }

  // ===========================================================================
  // OPERASI CRUD: PRODUK FAVORIT (WISHLIST)
  // ===========================================================================

  /// Menambahkan ID produk ke daftar favorit offline
  Future<void> addFavorite(String productId) async {
    final db = await instance.database;
    await db.insert(
      tableFavorites,
      {
        'product_id': productId,
        'added_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Menghapus produk dari daftar favorit
  Future<void> removeFavorite(String productId) async {
    final db = await instance.database;
    await db.delete(
      tableFavorites,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  /// Mengambil seluruh ID produk favorit
  Future<Set<String>> getAllFavoriteIds() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableFavorites);
    return maps.map((row) => row['product_id'] as String).toSet();
  }

  /// Mengosongkan seluruh favorit
  Future<void> clearAllFavorites() async {
    final db = await instance.database;
    await db.delete(tableFavorites);
  }

  /// Menutup koneksi database secara aman
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
