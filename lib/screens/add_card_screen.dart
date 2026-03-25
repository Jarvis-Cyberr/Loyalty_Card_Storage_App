import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loyalty_card.dart';
import '../providers/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _pointsController = TextEditingController(text: '0');

  String _selectedBarcodeType = 'qr';
  String _selectedCategory = 'General';
  String _selectedColor = '#6C63FF';
  DateTime? _expiryDate;

  final List<String> _categories = [
    'General', 'Grocery', 'Fashion', 'Electronics',
    'Restaurant', 'Pharmacy', 'Fuel', 'Travel'
  ];

  final List<Map<String, String>> _colors = [
    {'name': 'Purple', 'hex': '#6C63FF'},
    {'name': 'Orange', 'hex': '#FF6B35'},
    {'name': 'Green', 'hex': '#2ECC71'},
    {'name': 'Blue', 'hex': '#3498DB'},
    {'name': 'Red', 'hex': '#E74C3C'},
    {'name': 'Teal', 'hex': '#1ABC9C'},
  ];

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Loyalty Card'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _storeController,
              decoration: InputDecoration(
                labelText: 'Store / Brand Name',
                prefixIcon: const Icon(Icons.store),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter store name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter card number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Points',
                prefixIcon: const Icon(Icons.star),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBarcodeType,
              decoration: InputDecoration(
                labelText: 'Barcode Type',
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'qr', child: Text('QR Code')),
                DropdownMenuItem(
                    value: 'code128', child: Text('Barcode (Code 128)')),
              ],
              onChanged: (v) => setState(() => _selectedBarcodeType = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(_expiryDate == null
                  ? 'Set Expiry Date (optional)'
                  : 'Expires: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'),
              trailing: _expiryDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _expiryDate = null),
                    )
                  : null,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.now().add(const Duration(days: 365)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );
                if (date != null) setState(() => _expiryDate = date);
              },
            ),
            const SizedBox(height: 20),
            Text('Card Color',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: _colors.map((c) {
                final isSelected = _selectedColor == c['hex'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedColor = c['hex']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 46 : 40,
                    height: isSelected ? 46 : 40,
                    decoration: BoxDecoration(
                      color: _parseColor(c['hex']!),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color:
                                      _parseColor(c['hex']!).withOpacity(0.5),
                                  blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saveCard,
              icon: const Icon(Icons.save),
              label: const Text('Save Card'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCard() {
    if (!_formKey.currentState!.validate()) return;
    final card = LoyaltyCard(
      storeName: _storeController.text.trim(),
      cardNumber: _cardNumberController.text.trim(),
      barcodeType: _selectedBarcodeType,
      color: _selectedColor,
      expiryDate: _expiryDate,
      points: int.tryParse(_pointsController.text) ?? 0,
      category: _selectedCategory,
    );
    context.read<CardProvider>().addCard(card);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.storeName} card added!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _storeController.dispose();
    _cardNumberController.dispose();
    _pointsController.dispose();
    super.dispose();
  }
}