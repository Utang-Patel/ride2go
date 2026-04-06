import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class RideCompleteScreen extends StatefulWidget {
  final String pickup;
  final String drop;
  final String rideName;
  final String price;
  final String driverName;
  final String driverRating;
  final String paymentMethod;

  const RideCompleteScreen({
    super.key,
    required this.pickup,
    required this.drop,
    required this.rideName,
    required this.price,
    required this.driverName,
    required this.driverRating,
    required this.paymentMethod,
  });

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> with SingleTickerProviderStateMixin {
  int _rating = 0;
  bool _showTipSection = false;
  int _selectedTip = -1;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Animated success icon
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: AppColors.accent, size: 52),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Ride Complete!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      'You have arrived at ${widget.drop}',
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Fare card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(widget.price, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Paid via ${widget.paymentMethod}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          _fareRow('Ride', widget.rideName),
                          const SizedBox(height: 8),
                          _fareRow('From', widget.pickup),
                          const SizedBox(height: 8),
                          _fareRow('To', widget.drop),
                          const SizedBox(height: 8),
                          _fareRow('Driver', '${widget.driverName} ⭐ ${widget.driverRating}'),
                          const SizedBox(height: 8),
                          _fareRow('Distance', '3.2 km'),
                          const SizedBox(height: 8),
                          _fareRow('Duration', '12 min'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Rating section
                    const Text('Rate your ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'How was your experience with ${widget.driverName}?',
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) => GestureDetector(
                        onTap: () => setState(() {
                          _rating = i + 1;
                          _showTipSection = _rating >= 4;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedScale(
                            scale: i < _rating ? 1.2 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                              color: Colors.amber, size: 38,
                            ),
                          ),
                        ),
                      )),
                    ),
                    if (_rating > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _rating == 5 ? 'Excellent! 🎉' : _rating == 4 ? 'Great! 😊' : _rating == 3 ? 'Good 👍' : _rating == 2 ? 'Okay 😐' : 'Poor 😞',
                          style: TextStyle(
                            color: _rating >= 4 ? AppColors.accent : _rating == 3 ? Colors.orange : Colors.red,
                            fontWeight: FontWeight.bold, fontSize: 14,
                          ),
                        ),
                      ),
                    // Tip section
                    if (_showTipSection) ...[
                      const SizedBox(height: 20),
                      const Text('Leave a tip?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _tipChip('₹10', 0),
                          const SizedBox(width: 12),
                          _tipChip('₹20', 1),
                          const SizedBox(width: 12),
                          _tipChip('₹50', 2),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Bottom button
            Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipChip(String amount, int index) {
    final isSelected = _selectedTip == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTip = isSelected ? -1 : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _fareRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
