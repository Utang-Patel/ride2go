import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'parcel_booking_screen.dart';
import 'search_destination_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _transport = [
    {
      'name': 'Bike Lite',
      'desc': 'Fast & traffic-free',
      'icon': Icons.two_wheeler_outlined,
      'iconColor': 0xFF2EB086,
      'bgColor': 0xFFEAF8F3,
    },
    {
      'name': 'Bike',
      'desc': 'Standard two-wheeler',
      'icon': Icons.two_wheeler_outlined,
      'iconColor': 0xFF2EB086,
      'bgColor': 0xFFEAF8F3,
    },
    {
      'name': 'Auto',
      'desc': 'Reliable short distance',
      'icon': Icons.electric_rickshaw_outlined,
      'iconColor': 0xFF2EB086,
      'bgColor': 0xFFEAF8F3,
    },
    {
      'name': 'Cab Economy',
      'desc': 'Affordable daily rides',
      'icon': Icons.directions_car_outlined,
      'iconColor': 0xFF2D68FF,
      'bgColor': 0xFFF0F4FF,
    },
    {
      'name': 'Cab Premium',
      'desc': 'Top rated cars & drivers',
      'icon': Icons.directions_car_filled,
      'iconColor': 0xFF2D68FF,
      'bgColor': 0xFFF0F4FF,
    },
  ];

  static const _delivery = [
    {
      'name': 'Parcel',
      'desc': 'Small items & documents',
      'icon': Icons.inventory_2_outlined,
      'iconColor': 0xFFFC7753,
      'bgColor': 0xFFFFF3EE,
    },
    {
      'name': '3-Wheeler',
      'desc': 'Bulkier goods delivery',
      'icon': Icons.local_shipping_outlined,
      'iconColor': 0xFFDCA93F,
      'bgColor': 0xFFFDF7EA,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isTab = ModalRoute.of(context)?.settings.name == null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !isTab,
        leading: !isTab ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text(
          'Services',
          style: TextStyle(color: Color(0xFF1A1D1E), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: const Text(
              'EVERYTHING YOU NEED IN ONE PLACE',
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _sectionHeader('TRANSPORT'),
            const SizedBox(height: 12),
            ..._transport.map((s) => _serviceCard(context, s, false)),
            const SizedBox(height: 24),
            _sectionHeader('DELIVERY'),
            const SizedBox(height: 12),
            ..._delivery.map((s) => _serviceCard(context, s, true)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _infoCard(Icons.verified_user_outlined, 'Safety', 'CENTER', const Color(0xFF2D68FF))),
                const SizedBox(width: 16),
                Expanded(child: _infoCard(Icons.help_outline, 'Support', 'HELP', const Color(0xFFFC7753))),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8E8E93),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _serviceCard(BuildContext context, Map s, bool isParcel) {
    return GestureDetector(
      onTap: () {
        if (isParcel) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ParcelBookingScreen(),
          ));
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => SearchDestinationScreen(isParcel: false, preselectedService: s['name'] as String),
          ));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF2F2F7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(s['bgColor'] as int),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(s['icon'] as IconData, color: Color(s['iconColor'] as int), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF1A1D1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s['desc'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1D1E),
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8E8E93),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
