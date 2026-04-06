import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../theme/app_theme.dart';
import 'ride_complete_screen.dart';

class RideTrackingScreen extends StatefulWidget {
  final String pickup;
  final String drop;
  final String rideName;
  final String price;
  final String paymentMethod;

  const RideTrackingScreen({
    super.key,
    required this.pickup,
    required this.drop,
    required this.rideName,
    required this.price,
    required this.paymentMethod,
  });

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> with SingleTickerProviderStateMixin {
  int _step = 0; // 0=searching, 1=driver found, 2=on the way
  double _driverProgress = 0.0; // 0 to 1 for animation
  Timer? _progressTimer;
  late AnimationController _pulseController;

  final _driver = {
    'name': 'Rajesh Kumar',
    'rating': '4.8',
    'vehicle': 'KA 05 MN 1234',
    'trips': '1,240 rides',
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Step 1: Finding driver (2 sec)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _step = 1);
        // Start driver approach animation
        _startDriverAnimation();
      }
    });
  }

  void _startDriverAnimation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _driverProgress += 0.02;
        if (_driverProgress >= 0.5 && _step == 1) {
          _step = 2; // Switch to "ride in progress"
        }
        if (_driverProgress >= 1.0) {
          _driverProgress = 1.0;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _statusTitle {
    switch (_step) {
      case 0: return 'Finding your driver...';
      case 1: return 'Driver on the way';
      case 2: return 'Ride in progress';
      default: return '';
    }
  }

  String get _statusSubtitle {
    switch (_step) {
      case 0: return 'Please wait a moment';
      case 1: return 'Arriving in ~3 min';
      case 2: return 'Heading to your destination';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: _TrackingMapPainter(
                driverProgress: _driverProgress,
                showDriver: _step > 0,
              ),
            ),
          ),
          // Close / Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 3,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87, size: 20),
                onPressed: () => _showCancelDialog(),
              ),
            ),
          ),
          // Status badge at top
          if (_step > 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _step == 2 ? AppColors.accent : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _step == 2 ? Icons.navigation : Icons.local_taxi,
                        color: Colors.white, size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _step == 2 ? 'On the way to destination' : 'Driver is coming',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Driver marker on map
          if (_step > 0)
            Positioned(
              left: 40 + (_driverProgress * (MediaQuery.of(context).size.width - 120)),
              top: MediaQuery.of(context).size.height * 0.25
                  + math.sin(_driverProgress * math.pi) * 60,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3 + 0.2 * _pulseController.value),
                          blurRadius: 12 + 8 * _pulseController.value,
                          spreadRadius: 2 + 4 * _pulseController.value,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.rideName.toLowerCase().contains('bike')
                          ? Icons.two_wheeler
                          : widget.rideName.toLowerCase().contains('auto')
                              ? Icons.electric_rickshaw
                              : Icons.directions_car,
                      color: Colors.white, size: 20,
                    ),
                  );
                },
              ),
            ),
          // Pickup marker
          Positioned(
            left: 30, top: MediaQuery.of(context).size.height * 0.28,
            child: _mapPin(AppColors.accent, Icons.my_location, 'Pickup'),
          ),
          // Drop marker
          Positioned(
            right: 30, top: MediaQuery.of(context).size.height * 0.20,
            child: _mapPin(Colors.red, Icons.flag, 'Drop'),
          ),
          // Bottom sheet
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
              child: _step == 0 ? _buildSearching() : _buildDriverFound(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
          ),
          child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Ride?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to cancel this ride? Cancellation charges may apply.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep it'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearching() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 44, height: 44,
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
        ),
        const SizedBox(height: 16),
        const Text('Finding your driver...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('${widget.rideName} • ${widget.price}', style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        const SizedBox(height: 16),
        // Route summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _routeRow(Icons.my_location, AppColors.accent, widget.pickup),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(width: 1, height: 12, color: AppColors.divider),
              ),
              _routeRow(Icons.location_on, Colors.red, widget.drop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverFound() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_statusTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(_statusSubtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(widget.price,
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 12),
        // Driver info
        Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_driver['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(_driver['rating']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 12, color: AppColors.divider),
                      const SizedBox(width: 8),
                      Text(_driver['trips']!, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
            _actionBtn(Icons.message_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Chat with driver coming soon!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }),
            const SizedBox(width: 8),
            _actionBtn(Icons.call_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${_driver['name']}...'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        // Vehicle info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                widget.rideName.toLowerCase().contains('bike')
                    ? Icons.two_wheeler
                    : widget.rideName.toLowerCase().contains('auto')
                        ? Icons.electric_rickshaw
                        : Icons.directions_car,
                color: AppColors.primary, size: 18,
              ),
              const SizedBox(width: 8),
              Text(widget.rideName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Text(_driver['vehicle']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Route
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _routeRow(Icons.my_location, AppColors.accent, widget.pickup),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(width: 1, height: 12, color: AppColors.divider),
              ),
              _routeRow(Icons.location_on, Colors.red, widget.drop),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Complete ride button (shown when ride in progress)
        if (_step == 2)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (_) => RideCompleteScreen(
                  pickup: widget.pickup,
                  drop: widget.drop,
                  rideName: widget.rideName,
                  price: widget.price,
                  driverName: _driver['name']!,
                  driverRating: _driver['rating']!,
                  paymentMethod: widget.paymentMethod,
                ),
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Complete Ride', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        // Payment info
        if (_step == 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.payment, color: AppColors.textGrey, size: 16),
                const SizedBox(width: 8),
                Text('Payment: ${widget.paymentMethod}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                const Spacer(),
                Text(widget.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _routeRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

// Map painter for tracking screen
class _TrackingMapPainter extends CustomPainter {
  final double driverProgress;
  final bool showDriver;

  _TrackingMapPainter({required this.driverProgress, required this.showDriver});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFECF0F8),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFD5DCE8)
      ..strokeWidth = 0.5;

    // Street grid
    for (double x = 0; x < size.width; x += 35) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Blocks
    final blockPaint = Paint()
      ..color = const Color(0xFFDDE3EF)
      ..style = PaintingStyle.fill;

    final rng = math.Random(77);
    for (double x = 2; x < size.width - 35; x += 35) {
      for (double y = 2; y < size.height - 35; y += 35) {
        if (rng.nextDouble() > 0.35) {
          final w = 16 + rng.nextDouble() * 12;
          final h = 16 + rng.nextDouble() * 12;
          canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(x + 3, y + 3, w, h), const Radius.circular(2)),
            blockPaint,
          );
        }
      }
    }

    // Route line
    if (showDriver) {
      final routePaint = Paint()
        ..color = const Color(0xFF2D68FF).withOpacity(0.3)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final routePath = Path()
        ..moveTo(size.width * 0.15, size.height * 0.45)
        ..cubicTo(
          size.width * 0.35, size.height * 0.35,
          size.width * 0.65, size.height * 0.25,
          size.width * 0.85, size.height * 0.35,
        );
      canvas.drawPath(routePath, routePaint);

      // Completed route
      final completedPaint = Paint()
        ..color = const Color(0xFF2D68FF)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (final metric in routePath.computeMetrics()) {
        final completedPath = metric.extractPath(0, metric.length * driverProgress);
        canvas.drawPath(completedPath, completedPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrackingMapPainter oldDelegate) =>
      oldDelegate.driverProgress != driverProgress || oldDelegate.showDriver != showDriver;
}
