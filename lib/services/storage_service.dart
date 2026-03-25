import 'package:hive_flutter/hive_flutter.dart';
import '../models/loyalty_card.dart';
import 'encryption_service.dart';

class StorageService {
  static const _boxName = 'loyalty_cards';
  static Box<LoyaltyCard>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LoyaltyCardAdapter());
    _box = await Hive.openBox<LoyaltyCard>(_boxName);
  }

  static List<LoyaltyCard> getAllCards() {
    return _box?.values.map((card) {
      card.cardNumber = EncryptionService.decrypt(card.cardNumber);
      return card;
    }).toList() ?? [];
  }

  static Future<void> saveCard(LoyaltyCard card) async {
    final toSave = LoyaltyCard(
      id: card.id,
      storeName: card.storeName,
      cardNumber: EncryptionService.encrypt(card.cardNumber),
      barcodeType: card.barcodeType,
      color: card.color,
      expiryDate: card.expiryDate,
      points: card.points,
      category: card.category,
      createdAt: card.createdAt,
    );
    await _box?.put(card.id, toSave);
  }

  static Future<void> deleteCard(String id) async {
    await _box?.delete(id);
  }

  static Future<void> updateCard(LoyaltyCard card) async {
    await saveCard(card);
  }
}