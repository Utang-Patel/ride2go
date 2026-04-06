import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'ride_tracking_screen.dart';

class SelectRideScreen extends StatefulWidget {
  final String pickup;
  final String drop;
  final List<String> stops;
  final bool isParcel;
  final String? preselectedService;

  const SelectRideScreen({
    super.key,
    required this.pickup,
    required this.drop,
    this.stops = const [],
    this.isParcel = false,
    this.preselectedService,
  });

  @override
  State<SelectRideScreen> createState() => _SelectRideScreenState();
}

class _SelectRideScreenState extends State<SelectRideScreen> {
  int _selectedRide = 0;
  int _selectedPayment = 0;
  bool _isBooking = false;
  bool _isPoolMode = false;

  // Regular rides
  final _rides = [
    {'name': 'Bike Lite', 'icon': Icons.two_wheeler_outlined, 'price': '₹49', 'time': '2 min', 'desc': 'Fast & traffic-free', 'color': 0xFF9C27B0, 'poolable': false, 'seats': 1},
    {'name': 'Bike', 'icon': Icons.two_wheeler_outlined, 'price': '₹65', 'time': '3 min', 'desc': 'Standard two-wheeler', 'color': 0xFF673AB7, 'poolable': false, 'seats': 1},
    {'name': 'Auto', 'icon': Icons.electric_rickshaw_outlined, 'price': '₹120', 'time': '5 min', 'desc': 'Reliable short distance', 'color': 0xFF4CAF50, 'poolable': true, 'seats': 3},
    {'name': 'Cab Economy', 'icon': Icons.directions_car_outlined, 'price': '₹245', 'time': '4 min', 'desc': 'Affordable daily rides', 'color': 0xFF2196F3, 'poolable': true, 'seats': 4},
    {'name': 'Cab Premium', 'icon': Icons.directions_car_filled, 'price': '₹380', 'time': '6 min', 'desc': 'Top rated cars & drivers', 'color': 0xFFFF9800, 'poolable': true, 'seats': 4},
  ];

  // Pool prices (discounted)
  final _poolPrices = {
    'Auto': '₹75',
    'Cab Economy': '₹100',
    'Cab Premium': '₹140',
  };

  final _poolTimes = {
    'Auto': '8 min',
    'Cab Economy': '7 min',
    'Cab Premium': '9 min',
  };

  final _payments = ['Cash', 'UPI', 'Card', 'Wallet'];
  final _paymentIcons = [Icons.money, Icons.qr_code, Icons.credit_card, Icons.account_balance_wallet_outlined];

  int get _totalPoints => 2 + widget.stops.length;
  String get _totalDistance {
    final base = 3.2;
    final extra = widget.stops.length * 1.5;
    return '${(base + extra).toStringAsFixed(1)} km';
  }
  String get _totalTime {
    final base = 12;
    final extra = widget.stops.length * 5;
    return '${base + extra} min';
  }

  // Get available rides based on pool mode
  List<Map<String, dynamic>> get _availableRides {
    if (_isPoolMode) {
      // Only show poolable rides (Auto, Cab Economy, Cab Premium)
      return _rides.where((r) => r['poolable'] == true).toList();
    }
    return _rides;
  }

  @override
  void initState() {
    super.initState();
    if (widget.preselectedService != null) {
      final idx = _rides.indexWhere((r) => (r['name'] as String).toLowerCase().contains(widget.preselectedService!.toLowerCase()));
      if (idx != -1) _selectedRide = idx;
    }
  }

  void _togglePool() {
    setState(() {
      _isPoolMode = !_isPoolMode;
      _selectedRide = 0; // Reset selection when toggling
    });
  }

  String _getPrice(Map<String, dynamic> ride) {
    if (_isPoolMode) {
      return _poolPrices[ride['name']] ?? ride['price'] as String;
    }
    return ride['price'] as String;
  }

  String _getTime(Map<String, dynamic> ride) {
    if (_isPoolMode) {
      return _poolTimes[ride['name']] ?? ride['time'] as String;
    }
    return ride['time'] as String;
  }

  String _getDesc(Map<String, dynamic> ride) {
    if (_isPoolMode) {
      final seats = ride['seats'] as int;
      return 'Share ride • Up to $seats passengers';
    }
    return ride['desc'] as String;
  }

  void _bookRide() {
    final rides = _availableRides;
    final ride = rides[_selectedRide];
    setState(() => _isBooking = true);
    final fullDrop = widget.stops.isEmpty
        ? widget.drop
        : '${widget.stops.join(' → ')} → ${widget.drop}';
    final rideName = _isPoolMode ? '${ride['name']} Pool' : ride['name'] as String;
    final price = _getPrice(ride);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => RideTrackingScreen(
            pickup: widget.pickup,
            drop: fullDrop,
            rideName: rideName,
            price: price,
            paymentMethod: _payments[_selectedPayment],
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rides = _availableRides;
    final ride = rides[_selectedRide];
    final screenHeight = MediaQuery.of(context).size.height;
    final mapHeight = screenHeight * 0.42;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== MAP AREA =====
          SizedBox(
            height: mapHeight,
            child: Stack(
              children: [
                // Map background
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapPainter(),
                  ),
                ),
                // Route line through all points
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RoutePainter(stopCount: widget.stops.length),
                  ),
                ),
                // Pickup marker (bottom-left)
                Positioned(
                  left: 50,
                  bottom: mapHeight * 0.32,
                  child: _buildMapMarker(
                    color: AppColors.accent,
                    icon: Icons.my_location,
                    label: 'Pickup',
                  ),
                ),
                // Stop markers
                ...List.generate(widget.stops.length, (i) {
                  final fraction = (i + 1) / (_totalPoints - 1);
                  final left = 50 + fraction * (screenWidth - 140);
                  final verticalMid = mapHeight * 0.45;
                  final curveOffset = math.sin(fraction * math.pi) * mapHeight * 0.12;
                  final top = verticalMid - curveOffset;
                  return Positioned(
                    left: left - 19,
                    top: top - 25,
                    child: _buildMapMarker(
                      color: Colors.orange,
                      icon: Icons.flag_circle,
                      label: 'Stop ${i + 1}',
                    ),
                  );
                }),
                // Drop marker (top-right)
                Positioned(
                  right: 50,
                  top: mapHeight * 0.15,
                  child: _buildMapMarker(
                    color: Colors.red,
                    icon: Icons.location_on,
                    label: 'Destination',
                  ),
                ),
                // Distance badge
                Positioned(
                  left: screenWidth / 2 - 30,
                  top: mapHeight * 0.25,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
                    ),
                    child: Text(_totalDistance, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                      ),
                    ),
                  ),
                ),
                // Pool toggle button (top-right of map)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 12,
                  child: Material(
                    color: _isPoolMode ? AppColors.primary : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _togglePool,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.groups, size: 18,
                                color: _isPoolMode ? Colors.white : Colors.black54),
                            const SizedBox(width: 6),
                            Text(
                              'POOL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _isPoolMode ? Colors.white : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation button
                Positioned(
                  bottom: 60,
                  right: 16,
                  child: Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.near_me, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
                // Route info bar at bottom
                Positioned(
                  bottom: 10, left: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(widget.pickup, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                        ),
                        ...widget.stops.map((stop) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 1, height: 16, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 6)),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 60),
                              child: Text(stop, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        )),
                        Container(width: 1, height: 16, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 6)),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(widget.drop, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== RIDE OPTIONS =====
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _isPoolMode ? 'Pool Rides' : 'Choose a ride',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            if (widget.stops.isNotEmpty)
                              Text(
                                ' (${widget.stops.length} stop${widget.stops.length > 1 ? 's' : ''})',
                                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(8)),
                          child: Text('$_totalDistance • $_totalTime', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        ),
                      ],
                    ),
                  ),
                  // Pool info banner
                  if (_isPoolMode)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.groups, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Share your ride & save up to 40%! You may be matched with other riders.',
                              style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: rides.length,
                      itemBuilder: (_, i) => _rideOption(i, rides),
                    ),
                  ),
                  // Payment & Promo row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.divider)),
                    ),
                    child: Row(
                      children: [
                        const Text('Pay via', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_payments.length, (i) => GestureDetector(
                                onTap: () => setState(() => _selectedPayment = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _selectedPayment == i ? AppColors.primary : AppColors.bg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_paymentIcons[i], size: 14,
                                          color: _selectedPayment == i ? Colors.white : AppColors.textGrey),
                                      const SizedBox(width: 4),
                                      Text(_payments[i],
                                          style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w500,
                                            color: _selectedPayment == i ? Colors.white : AppColors.textGrey,
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Book button
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, MediaQuery.of(context).padding.bottom + 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isBooking ? null : _bookRide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.7),
                          disabledForegroundColor: Colors.white70,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _isBooking
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                                  SizedBox(width: 12),
                                  Text('Booking...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              )
                            : Text(
                                _isPoolMode
                                    ? 'Confirm ${ride['name']} Pool • ${_getPrice(ride)}'
                                    : 'Book ${ride['name']} • ${_getPrice(ride)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
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

  Widget _buildMapMarker({required Color color, required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 3)],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
          ),
          child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }

  Widget _rideOption(int i, List<Map<String, dynamic>> rides) {
    final ride = rides[i];
    final isSelected = _selectedRide == i;
    final price = _getPrice(ride);
    final time = _getTime(ride);
    final desc = _getDesc(ride);
    final rideColor = Color(ride['color'] as int);

    return GestureDetector(
      onTap: () => setState(() => _selectedRide = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: rideColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ride['icon'] as IconData, color: rideColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(ride['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 6),
                      // Passenger count
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, size: 12, color: AppColors.textGrey),
                          const SizedBox(width: 1),
                          Text('${ride['seats']}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                        ],
                      ),
                      // Pool badge
                      if (_isPoolMode) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('POOL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                      ],
                      // Premium badge
                      if (ride['name'] == 'Cab Premium' && !_isPoolMode) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('PREMIUM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                // Show original price struck through in pool mode
                if (_isPoolMode)
                  Text(
                    ride['price'] as String,
                    style: const TextStyle(fontSize: 10, color: AppColors.textGrey, decoration: TextDecoration.lineThrough),
                  ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 11, color: AppColors.textGrey),
                    const SizedBox(width: 2),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for map grid/street pattern
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF0F3FA),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFDADFEB)
      ..strokeWidth = 0.8;

    for (double x = 0; x < size.width; x += 45) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 45) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final blockPaint = Paint()
      ..color = const Color(0xFFE3E8F2)
      ..style = PaintingStyle.fill;

    final rng = math.Random(42);
    for (double x = 5; x < size.width - 45; x += 45) {
      for (double y = 5; y < size.height - 45; y += 45) {
        if (rng.nextDouble() > 0.3) {
          final w = 22 + rng.nextDouble() * 14;
          final h = 22 + rng.nextDouble() * 14;
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(x + 5, y + 5, w, h), const Radius.circular(3)),
            blockPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Route painter that draws through pickup → stops → destination
class _RoutePainter extends CustomPainter {
  final int stopCount;
  _RoutePainter({this.stopCount = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D68FF)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final totalPoints = 2 + stopCount;
    final points = <Offset>[];

    points.add(Offset(70, size.height * 0.68));

    for (int i = 0; i < stopCount; i++) {
      final fraction = (i + 1) / (totalPoints - 1);
      final x = 70 + fraction * (size.width - 140);
      final baseY = size.height * 0.68 - fraction * (size.height * 0.68 - size.height * 0.22);
      final curveOffset = math.sin(fraction * math.pi) * size.height * 0.08;
      points.add(Offset(x, baseY - curveOffset));
    }

    points.add(Offset(size.width - 70, size.height * 0.22));

    if (points.length >= 2) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      if (points.length == 2) {
        final midX = (points[0].dx + points[1].dx) / 2;
        final midY = (points[0].dy + points[1].dy) / 2 - size.height * 0.05;
        path.quadraticBezierTo(midX, midY, points[1].dx, points[1].dy);
      } else {
        for (int i = 0; i < points.length - 1; i++) {
          final current = points[i];
          final next = points[i + 1];
          final midX = (current.dx + next.dx) / 2;
          final midY = (current.dy + next.dy) / 2;
          path.quadraticBezierTo(current.dx + (next.dx - current.dx) * 0.5, current.dy, midX, midY);
        }
        final last = points.last;
        path.lineTo(last.dx, last.dy);
      }

      final dashPath = Path();
      const dashWidth = 10.0;
      const dashSpace = 5.0;
      for (final metric in path.computeMetrics()) {
        double distance = 0;
        while (distance < metric.length) {
          final next = distance + dashWidth;
          dashPath.addPath(
            metric.extractPath(distance, next.clamp(0, metric.length)),
            Offset.zero,
          );
          distance = next + dashSpace;
        }
      }
      canvas.drawPath(dashPath, paint);

      if (stopCount > 0) {
        final dotPaint = Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.fill;
        for (int i = 1; i <= stopCount; i++) {
          canvas.drawCircle(points[i], 5, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => oldDelegate.stopCount != stopCount;
}
