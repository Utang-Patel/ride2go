import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'search_destination_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final _rides = [
    {
      'type': 'Cab Economy',
      'icon': Icons.directions_car_outlined,
      'iconColor': 0xFF2D68FF,
      'bgColor': 0xFFF0F4FF,
      'date': 'MAR 24, 2026',
      'time': '10:30 AM',
      'price': '₹245',
      'status': 'COMPLETED',
      'pickup': '123 Business Hub, Downtown',
      'drop': 'Central Railway Station',
      'isParcel': false,
    },
    {
      'type': 'Parcel',
      'icon': Icons.inventory_2_outlined,
      'iconColor': 0xFFFC7753,
      'bgColor': 0xFFFFF3EE,
      'date': 'MAR 22, 2026',
      'time': '02:15 PM',
      'price': '₹45',
      'status': 'COMPLETED',
      'pickup': 'Home, Green Woods',
      'drop': "St. Mary's Hospital",
      'isParcel': true,
    },
    {
      'type': 'Auto',
      'icon': Icons.electric_rickshaw_outlined,
      'iconColor': 0xFF2EB086,
      'bgColor': 0xFFEAF8F3,
      'date': 'MAR 18, 2026',
      'time': '06:45 PM',
      'price': '₹120',
      'status': 'COMPLETED',
      'pickup': 'City Mall Entrance',
      'drop': 'Lakeview Apartment',
      'isParcel': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF1A1D1E), size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Activity',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F4FF),
                foregroundColor: const Color(0xFF2D68FF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('PAST', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _rides.length,
        itemBuilder: (_, i) => _rideCard(_rides[i]),
      ),
    );
  }

  Widget _rideCard(Map ride) {
    final bool isCompleted = ride['status'] == 'COMPLETED';
    final Color primaryColor = Color(ride['iconColor'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF2F2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(ride['bgColor'] as int),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(ride['icon'] as IconData, color: primaryColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride['type'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1A1D1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 14, color: const Color(0xFF8E8E93)),
                                const SizedBox(width: 6),
                                Text(
                                  ride['date'] as String,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 14),
                                Icon(Icons.access_time_rounded, size: 14, color: const Color(0xFF8E8E93)),
                                const SizedBox(width: 6),
                                Text(
                                  ride['time'] as String,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ride['price'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF2D68FF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFFEAF8F3) : const Color(0xFFFFEFEF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ride['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? const Color(0xFF2EB086) : const Color(0xFFFF3B30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Timeline
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2D68FF), width: 3),
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4B4B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _locationSection('PICKUP', ride['pickup'] as String),
                          const SizedBox(height: 28),
                          _locationSection('DROP', ride['drop'] as String),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    ride['isParcel'] == true ? 'REORDER' : 'REBOOK',
                    style: const TextStyle(
                      color: Color(0xFF2D68FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Text(
                        'DETAILS',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF8E8E93)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationSection(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E8E93),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          address,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D1E),
          ),
        ),
      ],
    );
  }
}
