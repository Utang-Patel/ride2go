import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class ParcelTrackingScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final String senderName;
  final String receiverName;
  final String fare;
  final String parcelType;
  final bool sameDayDelivery;

  const ParcelTrackingScreen({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.senderName,
    required this.receiverName,
    required this.fare,
    required this.parcelType,
    required this.sameDayDelivery,
  });

  @override
  State<ParcelTrackingScreen> createState() => _ParcelTrackingScreenState();
}

class _ParcelTrackingScreenState extends State<ParcelTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcel Tracking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, color: AppColors.primary, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your parcel (${widget.parcelType}) will be picked up soon.',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Fare: ${widget.fare}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Return to the first route in the navigator stack
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}