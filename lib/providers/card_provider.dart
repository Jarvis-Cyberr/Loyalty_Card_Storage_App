import 'package:flutter/material.dart';
import '../models/loyalty_card.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class CardProvider extends ChangeNotifier {
  List<LoyaltyCard> _cards = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<LoyaltyCard> get cards => _filteredCards();
  List<LoyaltyCard> get allCards => _cards;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories =>
      ['All', ..._cards.map((c) => c.category).toSet().toList()];

  void loadCards() {
    _cards = StorageService.getAllCards();
    notifyListeners();
  }

  List<LoyaltyCard> _filteredCards() {
    return _cards.where((card) {
      final matchesSearch =
          card.storeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              card.cardNumber.contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'All' || card.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addCard(LoyaltyCard card) async {
    await StorageService.saveCard(card);
    NotificationService.addNotification(
      '✅ Card Added!',
      '${card.storeName} loyalty card has been saved.',
    );
    if (card.expiresWithin30Days) {
      NotificationService.addNotification(
        '⚠️ Expiry Alert!',
        '${card.storeName} card expires within 30 days!',
      );
    }
    loadCards();
  }

  Future<void> deleteCard(LoyaltyCard card) async {
    await StorageService.deleteCard(card.id);
    NotificationService.addNotification(
      '🗑️ Card Removed',
      '${card.storeName} card has been deleted.',
    );
    loadCards();
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await StorageService.updateCard(card);
    loadCards();
  }

  List<LoyaltyCard> get expiringCards =>
      _cards.where((c) => c.expiresWithin30Days).toList();

  List<LoyaltyCard> get expiredCards =>
      _cards.where((c) => c.isExpired).toList();
}