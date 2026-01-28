class Medicine {
  final String id;
  final String name;
  final String dosage;
  final List<String> schedule; // 例如: ['08:00', '12:00', '18:00']
  final String frequency; // 'daily', 'twice_daily', 'once_daily', 'custom'
  final DateTime createdAt;
  final bool isActive;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.schedule,
    required this.frequency,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'schedule': schedule.join(','),
      'frequency': frequency,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      schedule: map['schedule'].toString().split(','),
      frequency: map['frequency'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isActive: map['isActive'] == 1,
    );
  }

  // 检查今天是否已经服用
  bool isTakenToday(List<MedicineIntake> intakes) {
    final today = DateTime.now();
    return intakes.any((intake) =>
        intake.medicineId == id &&
        intake.time.day == today.day &&
        intake.time.month == today.month &&
        intake.time.year == today.year);
  }
}

class MedicineIntake {
  final String id;
  final String medicineId;
  final DateTime time;
  final String note; // 可选备注

  MedicineIntake({
    required this.id,
    required this.medicineId,
    required this.time,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'time': time.millisecondsSinceEpoch,
      'note': note,
    };
  }

  factory MedicineIntake.fromMap(Map<String, dynamic> map) {
    return MedicineIntake(
      id: map['id'],
      medicineId: map['medicineId'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      note: map['note'],
    );
  }
}