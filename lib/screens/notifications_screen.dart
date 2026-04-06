import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('3 New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('NEW'),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.card_giftcard,
              iconBgOption: 0xFFFF7043,
              title: '🎉 Special Offer!',
              desc: 'Get 20% off on your next 3 rides. Valid till tomorrow!',
              time: '5 min ago',
              isUnread: true,
            ),
            _notificationCard(
              icon: Icons.directions_car_outlined,
              iconBgOption: 0xFF2D68FF,
              title: 'Ride Completed',
              desc: 'Your ride to MG Road has been completed. Rate your driver!',
              time: '1 hour ago',
              isUnread: true,
            ),
            _notificationCard(
              icon: Icons.inventory_2_outlined,
              iconBgOption: 0xFF00C853,
              title: 'Parcel Delivered',
              desc: 'Your parcel has been successfully delivered to the destination.',
              time: '2 hours ago',
              isUnread: true,
            ),
            const SizedBox(height: 16),
            _sectionHeader('EARLIER'),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.star_border,
              iconBgOption: 0xFFAA00FF,
              title: '⭐ You\'re a Star Rider!',
              desc: 'Congratulations! You\'ve completed 50 rides. Unlock exclusive benefits.',
              time: '5 hours ago',
              isUnread: false,
            ),
            _notificationCard(
              icon: Icons.location_on_outlined,
              iconBgOption: 0xFF2D68FF,
              title: 'Driver Arriving Soon',
              desc: 'Your driver is 2 mins away from your pickup location.',
              time: 'Yesterday',
              isUnread: false,
            ),
            _notificationCard(
              icon: Icons.notifications_none,
              iconBgOption: 0xFFFF6D00,
              title: 'Welcome to Ride2Go!',
              desc: 'Thank you for joining us. Get ₹100 off on your first ride.',
              time: '2 days ago',
              isUnread: false,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF78909C), // Steel blue/grey color in original image 
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required int iconBgOption,
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? AppColors.primary.withOpacity(0.3) : const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(iconBgOption),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Color(0xFF607D8B), fontSize: 13, height: 1.3)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Color(0xFF90A4AE)),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF90A4AE))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
