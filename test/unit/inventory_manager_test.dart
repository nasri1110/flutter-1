import 'package:flutter_test/flutter_test.dart';
import 'package:sayur_hub/core/utils/inventory_manager.dart';

void main() {
  group('InventoryManager Unit Tests (Logika Diskon Bertingkat & Mutu Komoditas)', () {
    test('calculateVolumeDiscount menerapkan tier diskon volume secara tepat', () {
      const double basePrice = 20000.0;

      // Tier 1: Di bawah 3 kg -> 0%
      expect(InventoryManager.calculateVolumeDiscount(quantityKg: 2, pricePerKg: basePrice), equals(0.0));

      // Tier 2: 3 s/d 5 kg -> 5% diskon
      // 4 kg * 20.000 = 80.000 -> diskon 5% = 4.000
      expect(InventoryManager.calculateVolumeDiscount(quantityKg: 4, pricePerKg: basePrice), equals(4000.0));

      // Tier 3: Di atas 5 kg -> 10% diskon
      // 10 kg * 20.000 = 200.000 -> diskon 10% = 20.000
      expect(InventoryManager.calculateVolumeDiscount(quantityKg: 10, pricePerKg: basePrice), equals(20000.0));
    });

    test('evaluateProduceGrade menilai kelas mutu komoditas sayur', () {
      expect(InventoryManager.evaluateProduceGrade(freshnessHours: 4, isOrganic: true), equals('Grade A+ (Super Organik)'));
      expect(InventoryManager.evaluateProduceGrade(freshnessHours: 12, isOrganic: false), equals('Grade A (Segar Standar)'));
      expect(InventoryManager.evaluateProduceGrade(freshnessHours: 30, isOrganic: false), equals('Grade B (Diskon Cuci Gudang)'));
      expect(InventoryManager.evaluateProduceGrade(freshnessHours: 60, isOrganic: false), equals('Grade C (Tidak Layak Jual)'));
    });
  });
}
