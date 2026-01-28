import 'package:flutter/foundation.dart';
import '../models/medicine.dart';
import '../services/database_service.dart';

class MedicineProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Medicine> _medicines = [];
  List<MedicineIntake> _intakes = [];

  List<Medicine> get medicines => _medicines;
  List<MedicineIntake> get intakes => _intakes;

  Future<void> loadAllData() async {
    _medicines = await _databaseService.getMedicines();
    // Load intakes for all medicines (you might want to optimize this)
    for (var medicine in _medicines) {
      final intakes = await _databaseService.getIntakesByMedicine(medicine.id);
      _intakes.addAll(intakes);
    }
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _databaseService.insertMedicine(medicine);
    _medicines.add(medicine);
    notifyListeners();
  }

  Future<void> markAsTaken(String medicineId, {String note = ''}) async {
    final intake = MedicineIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId,
      time: DateTime.now(),
      note: note,
    );
    
    await _databaseService.insertIntake(intake);
    _intakes.add(intake);
    notifyListeners();
  }

  bool isMedicineTakenToday(String medicineId) {
    final today = DateTime.now();
    return _intakes.any((intake) =>
        intake.medicineId == medicineId &&
        intake.time.day == today.day &&
        intake.time.month == today.month &&
        intake.time.year == today.year);
  }

  List<Medicine> getTodaysMedicines() {
    return _medicines.where((medicine) {
      bool isTaken = isMedicineTakenToday(medicine.id);
      return !isTaken; // Return only medicines not taken today
    }).toList();
  }

  List<MedicineIntake> getTodaysIntakes() {
    final today = DateTime.now();
    return _intakes.where((intake) =>
        intake.time.day == today.day &&
        intake.time.month == today.month &&
        intake.time.year == today.year
    ).toList();
  }
}