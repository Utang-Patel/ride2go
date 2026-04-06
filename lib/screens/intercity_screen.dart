import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'select_ride_screen.dart';

class IntercityScreen extends StatefulWidget {
  const IntercityScreen({super.key});

  @override
  State<IntercityScreen> createState() => _IntercityScreenState();
}

class _IntercityScreenState extends State<IntercityScreen> {
  int _selectedRoute = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  final _routes = [
    {'from': 'Bangalore', 'to': 'Chennai', 'duration': '5h 30m', 'distance': '346 km', 'price': '₹899', 'popular': true},
    {'from': 'Bangalore', 'to': 'Hyderabad', 'duration': '6h 00m', 'distance': '570 km', 'price': '₹1,199', 'popular': true},
    {'from': 'Bangalore', 'to': 'Mysore', 'duration': '2h 30m', 'distance': '145 km', 'price': '₹489', 'popular': false},
    {'from': 'Bangalore', 'to': 'Coimbatore', 'duration': '4h 00m', 'distance': '248 km', 'price': '₹699', 'popular': false},
    {'from': 'Bangalore', 'to': 'Goa', 'duration': '8h 00m', 'distance': '560 km', 'price': '₹1,499', 'popular': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&h=400&fit=crop',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.55),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
                  ),
                  const Positioned(
                    bottom: 20, left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Intercity Rides', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('Travel across cities with comfort', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date picker
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Travel Date', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                              Text(
                                '${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Popular Routes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ..._routes.asMap().entries.map((e) => _routeCard(context, e.key, e.value)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeCard(BuildContext context, int i, Map route) {
    final isSelected = _selectedRoute == i;
    return GestureDetector(
      onTap: () => setState(() => _selectedRoute = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(route['from'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, size: 16, color: AppColors.textGrey),
                          ),
                          Text(route['to'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          if (route['popular'] == true) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: const Text('POPULAR', style: TextStyle(fontSize: 9, color: AppColors.accent, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${route['distance']} • ${route['duration']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                    ],
                  ),
                ),
                Text(route['price'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => SelectRideScreen(
                      pickup: route['from'] as String,
                      drop: route['to'] as String,
                      preselectedService: 'Cab Economy',
                    ),
                  )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Book This Route', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
