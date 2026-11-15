import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sayur_hub/shared/widgets/quantity_counter_widget.dart';

void main() {
  group('QuantityCounterWidget Tests (Komponen Stepper Kuantitas Sayur)', () {
    testWidgets('Menampilkan kuantitas awal 1 kg dengan benar', (WidgetTester tester) async {
      int currentQuantity = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityCounterWidget(
              initialQuantity: 1,
              maxStock: 10,
              onQuantityChanged: (val) {
                currentQuantity = val;
              },
            ),
          ),
        ),
      );

      // Verifikasi teks 1 kg tampil
      expect(find.text('1 kg'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    });

    testWidgets('Menekan tombol plus (+) menambah kuantitas menjadi 2 kg', (WidgetTester tester) async {
      int currentQuantity = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityCounterWidget(
              initialQuantity: 1,
              maxStock: 10,
              onQuantityChanged: (val) {
                currentQuantity = val;
              },
            ),
          ),
        ),
      );

      // Aksi: Ketuk tombol tambah
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump(); // Render ulang perubahan state lokal

      // Verifikasi teks berubah menjadi 2 kg dan callback terpicu
      expect(find.text('2 kg'), findsOneWidget);
      expect(currentQuantity, equals(2));
    });

    testWidgets('Tidak mengizinkan kuantitas melebihi batas maxStock', (WidgetTester tester) async {
      int currentQuantity = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityCounterWidget(
              initialQuantity: 3,
              maxStock: 3, // Maksimal stok hanya 3
              onQuantityChanged: (val) {
                currentQuantity = val;
              },
            ),
          ),
        ),
      );

      // Aksi: Mencoba mengetuk tombol tambah saat sudah mencapai maxStock
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      // Kuantitas harus tetap 3 kg (tidak boleh bertambah)
      expect(find.text('3 kg'), findsOneWidget);
      expect(currentQuantity, equals(3));
    });
  });
}
