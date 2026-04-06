import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'select_delivery_mode_screen.dart';

class ParcelBookingScreen extends StatefulWidget {
  const ParcelBookingScreen({super.key});

  @override
  State<ParcelBookingScreen> createState() => _ParcelBookingScreenState();
}

class _ParcelBookingScreenState extends State<ParcelBookingScreen> {
  bool _sameDayDelivery = false;
  int _selectedType = 0;

  final _pickupAddressCtrl = TextEditingController();
  final _senderNameCtrl = TextEditingController();
  final _senderPhoneCtrl = TextEditingController();
  final _dropAddressCtrl = TextEditingController();
  final _receiverNameCtrl = TextEditingController();
  final _receiverPhoneCtrl = TextEditingController();

  final _parcelTypes = [
    {'label': 'Documents', 'icon': Icons.description_outlined, 'color': 0xFF2196F3},
    {'label': 'Small Box', 'icon': Icons.inventory_2_outlined, 'color': 0xFF4CAF50},
    {'label': 'Medium Box', 'icon': Icons.inventory_outlined, 'color': 0xFFFF9800},
    {'label': 'Large Box', 'icon': Icons.local_shipping_outlined, 'color': 0xFF9C27B0},
  ];

  @override
  void dispose() {
    _pickupAddressCtrl.dispose();
    _senderNameCtrl.dispose();
    _senderPhoneCtrl.dispose();
    _dropAddressCtrl.dispose();
    _receiverNameCtrl.dispose();
    _receiverPhoneCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _pickupAddressCtrl.text.trim().isNotEmpty &&
      _senderNameCtrl.text.trim().isNotEmpty &&
      _senderPhoneCtrl.text.trim().isNotEmpty &&
      _dropAddressCtrl.text.trim().isNotEmpty &&
      _receiverNameCtrl.text.trim().isNotEmpty &&
      _receiverPhoneCtrl.text.trim().isNotEmpty;

  String get _estimatedFare => _sameDayDelivery ? '₹150 - 200' : '₹85 - 120';
  String get _deliveryLabel => _sameDayDelivery ? 'Same Day Delivery' : 'Standard Delivery';

  void _confirm() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => SelectDeliveryModeScreen(
        pickupAddress: _pickupAddressCtrl.text,
        dropAddress: _dropAddressCtrl.text,
        senderName: _senderNameCtrl.text,
        receiverName: _receiverNameCtrl.text,
        parcelType: _parcelTypes[_selectedType]['label'] as String,
        sameDayDelivery: _sameDayDelivery,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Parcel Details', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('SEND ANYTHING ANYWHERE', style: TextStyle(color: Colors.black45, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            child: Stack(
              children: [
                // Blue Banner now scrolls with content
                Container(
                  height: 140,
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fast & Reliable\nDelivery',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Same Day Delivery', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ),
                
                // Form Cards
                Padding(
                  padding: EdgeInsets.only(top: 100, bottom: MediaQuery.of(context).padding.bottom + 140),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF0F0F0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: _buildFormSection(
                            isPickup: true,
                            title: 'PICKUP DETAILS',
                            iconColor: AppColors.primary,
                            addressCtrl: _pickupAddressCtrl,
                            nameCtrl: _senderNameCtrl,
                            nameHint: "SENDER'S NAME",
                            phoneCtrl: _senderPhoneCtrl,
                          ),
                        ),
                        // Dashed line connector
                        Row(
                          children: [
                            const SizedBox(width: 31), // Align with icons
                            Container(
                              width: 1,
                              height: 24,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [AppColors.primary, Colors.redAccent],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Receiver Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF0F0F0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: _buildFormSection(
                            isPickup: false,
                            title: 'RECEIVER DETAILS',
                            iconColor: Colors.redAccent,
                            addressCtrl: _dropAddressCtrl,
                            nameCtrl: _receiverNameCtrl,
                            nameHint: "RECEIVER'S NAME",
                            phoneCtrl: _receiverPhoneCtrl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ESTIMATED FARE', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Text('₹85 - 120', style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: const [
                          Text('Standard Delivery', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Confirm Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required bool isPickup,
    required String title,
    required Color iconColor,
    required TextEditingController addressCtrl,
    required TextEditingController nameCtrl,
    required String nameHint,
    required TextEditingController phoneCtrl,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.circle, color: iconColor, size: 10),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputLabel('COMPLETE ADDRESS'),
          const SizedBox(height: 8),
          _buildInputField(
            controller: addressCtrl,
            hint: 'Street name, landmark, building number...',
            icon: Icons.location_on_outlined,
            iconColor: iconColor,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel(nameHint),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: nameCtrl,
                      hint: 'Name',
                      icon: Icons.person_outline,
                      iconColor: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('PHONE NUMBER'),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: phoneCtrl,
                      hint: '+91...',
                      icon: Icons.phone_outlined,
                      iconColor: Colors.black45,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 0.5),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: iconColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
