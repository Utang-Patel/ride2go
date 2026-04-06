import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'parcel_tracking_screen.dart';

class SelectDeliveryModeScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final String senderName;
  final String receiverName;
  final String parcelType;
  final bool sameDayDelivery;

  const SelectDeliveryModeScreen({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.senderName,
    required this.receiverName,
    required this.parcelType,
    required this.sameDayDelivery,
  });

  @override
  State<SelectDeliveryModeScreen> createState() => _SelectDeliveryModeScreenState();
}

class _SelectDeliveryModeScreenState extends State<SelectDeliveryModeScreen> {
  int _selectedMode = 0;
  bool _isOrdering = false;

  final _deliveryModes = [
    {
      'name': 'Parcel',
      'desc': 'Standard bike delivery',
      'time': '4 mins away',
      'price': '₹45',
      'weight': 'Up to 5 kg',
      'icon': Icons.inventory_2_outlined,
      'color': 0xFF2D68FF,
      'insured': true,
    },
    {
      'name': 'Parcel 3-wheeler',
      'desc': 'Large cargo delivery',
      'time': '8 mins away',
      'price': '₹115',
      'weight': 'Up to 50 kg',
      'icon': Icons.local_shipping_outlined,
      'color': 0xFF7C4DFF,
      'insured': true,
    },
  ];

  void _orderParcel() {
    final mode = _deliveryModes[_selectedMode];
    setState(() => _isOrdering = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ParcelTrackingScreen(
            pickupAddress: widget.pickupAddress,
            dropAddress: widget.dropAddress,
            senderName: widget.senderName,
            receiverName: widget.receiverName,
            fare: mode['price'] as String,
            parcelType: '${widget.parcelType} (${mode['name']})',
            sameDayDelivery: widget.sameDayDelivery,
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Responsive map height: 30% on small screens, max 280
    final mapHeight = (screenHeight * 0.30).clamp(180.0, 280.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // ===== MAP AREA =====
            SizedBox(
              height: mapHeight + statusBarHeight,
              child: Stack(
                children: [
                  // Map background
                  Positioned.fill(
                    child: CustomPaint(painter: _ParcelMapPainter()),
                  ),
                  // Route line
                  Positioned.fill(
                    child: CustomPaint(painter: _ParcelRoutePainter()),
                  ),
                  // Pickup marker
                  Positioned(
                    left: 40,
                    bottom: mapHeight * 0.28,
                    child: _buildMapMarker(
                      color: AppColors.accent,
                      icon: Icons.my_location,
                      label: 'Pickup',
                    ),
                  ),
                  // Drop marker
                  Positioned(
                    right: 40,
                    top: statusBarHeight + mapHeight * 0.18,
                    child: _buildMapMarker(
                      color: Colors.red,
                      icon: Icons.location_on,
                      label: 'Drop',
                    ),
                  ),
                  // Parcel icon on route
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.36,
                    top: statusBarHeight + mapHeight * 0.35,
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 20),
                    ),
                  ),
                  // Distance badge
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 + 10,
                    top: statusBarHeight + mapHeight * 0.28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: const Text('2.8 km', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: statusBarHeight + 8,
                    left: 12,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                        ),
                      ),
                    ),
                  ),
                  // Title badge
                  Positioned(
                    top: statusBarHeight + 10,
                    left: 60, right: 60,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                        ),
                        child: const Text(
                          'SELECT DELIVERY MODE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  // Route info bar
                  Positioned(
                    bottom: 8, left: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                      ),
                      child: Row(
                        children: [
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Expanded(child: Text(widget.pickupAddress, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                          Container(width: 1, height: 14, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 6)),
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Expanded(child: Text(widget.dropAddress, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== DELIVERY MODE OPTIONS =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                children: [
                  ...List.generate(_deliveryModes.length, (i) => _deliveryOption(i)),
                  const SizedBox(height: 12),
                  // About Parcel info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.info_outline, color: AppColors.primary, size: 14),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ABOUT PARCEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
                              const SizedBox(height: 3),
                              Text(
                                _selectedMode == 0
                                    ? 'Fast delivery for small items like documents, food, or small electronics.'
                                    : 'Large cargo delivery for heavy items, furniture, or bulk orders.',
                                style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sender → Receiver summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _summaryRow(Icons.person, 'Sender', widget.senderName),
                        const SizedBox(height: 6),
                        _summaryRow(Icons.person_outline, 'Receiver', widget.receiverName),
                        const SizedBox(height: 6),
                        _summaryRow(Icons.inventory_2_outlined, 'Type', widget.parcelType),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPadding + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isOrdering ? null : _orderParcel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _isOrdering
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text('Ordering...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Order ${_deliveryModes[_selectedMode]['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapMarker({required Color color, required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, spreadRadius: 1)],
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 3)],
          ),
          child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }

  Widget _deliveryOption(int i) {
    final mode = _deliveryModes[i];
    final isSelected = _selectedMode == i;
    final modeColor = Color(mode['color'] as int);

    return GestureDetector(
      onTap: () => setState(() => _selectedMode = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? modeColor.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? modeColor : const Color(0xFFE8E8E8),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: modeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(mode['icon'] as IconData, color: modeColor, size: 22),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and time - wrapped to prevent overflow
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        mode['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        mode['time'] as String,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(mode['desc'] as String, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.scale_outlined, size: 11, color: Colors.grey.shade400),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(mode['weight'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Price + Insured
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  mode['price'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                if (mode['insured'] == true)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user, size: 10, color: AppColors.accent),
                      const SizedBox(width: 2),
                      Text('INSURED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accent)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

// Map painter
class _ParcelMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFF0F3FA));

    final gridPaint = Paint()..color = const Color(0xFFDADFEB)..strokeWidth = 0.7;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final blockPaint = Paint()..color = const Color(0xFFE3E8F2)..style = PaintingStyle.fill;
    final rng = math.Random(55);
    for (double x = 4; x < size.width - 40; x += 40) {
      for (double y = 4; y < size.height - 40; y += 40) {
        if (rng.nextDouble() > 0.3) {
          final w = 18 + rng.nextDouble() * 12;
          final h = 18 + rng.nextDouble() * 12;
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 4, y + 4, w, h), const Radius.circular(2)), blockPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParcelRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D68FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(55, size.height * 0.65)
      ..lineTo(55, size.height * 0.42)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.28, size.width * 0.5, size.height * 0.33)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.38, size.width - 55, size.height * 0.28);

    final dashPath = Path();
    const dw = 7.0, ds = 4.0;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final n = d + dw;
        dashPath.addPath(m.extractPath(d, n.clamp(0, m.length)), Offset.zero);
        d = n + ds;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
