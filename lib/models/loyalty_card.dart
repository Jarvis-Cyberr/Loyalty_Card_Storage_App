import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'loyalty_card.g.dart';

@HiveType(typeId: 0)
class LoyaltyCard extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String storeName;

  @HiveField(2)
  late String cardNumber;

  @HiveField(3)
  late String barcodeType;

  @HiveField(4)
  late String color;

  @HiveField(5)
  late DateTime? expiryDate;

  @HiveField(6)
  late int points;

  @HiveField(7)
  late String category;

  @HiveField(8)
  late DateTime createdAt;

  LoyaltyCard({
    String? id,
    required this.storeName,
    required this.cardNumber,
    this.barcodeType = 'qr',
    this.color = '#6C63FF',
    this.expiryDate,
    this.points = 0,
    this.category = 'General',
    DateTime? createdAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get expiresWithin30Days =>
      expiryDate != null &&
      expiryDate!.isAfter(DateTime.now()) &&
      expiryDate!.isBefore(DateTime.now().add(const Duration(days: 30)));
}