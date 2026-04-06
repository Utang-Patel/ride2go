import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'search_destination_screen.dart';
import 'services_screen.dart';
import 'offers_screen.dart';
import 'intercity_screen.dart';
import 'notifications_screen.dart';
import 'parcel_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0=Rides, 1=Parcel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRideTabsAndSearch(),
                    _buildServicesSection(),
                    _buildForYouSection(),
                    _buildIntercityBanner(),
                    _buildGoPlaces(),
                    _buildBetterAccuracy(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'ride', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                TextSpan(text: '2go', style: TextStyle(color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            child: Stack(
              children: [
                const Icon(Icons.notifications_none_outlined, color: Colors.black87, size: 28),
                Positioned(
                  right: 2, top: 4,
                  child: Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideTabsAndSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTab('Rides', 0, Icons.directions_car_outlined)),
                Expanded(child: _buildTab('Parcel', 1, Icons.inventory_2_outlined)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => SearchDestinationScreen(isParcel: _selectedTab == 1),
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5EA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFFC4C4C4), size: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Enter pickup location',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
        if (index == 1) {
          // If Parcel is selected, immediately navigate to the ParcelBookingScreen
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ParcelBookingScreen())).then((_) {
              // Reset back to Rides when returning
              if (mounted) setState(() => _selectedTab = 0);
            });
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF8E8E93)),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF8E8E93),
                  fontWeight: FontWeight.bold, fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {'label': 'Parcel', 'icon': Icons.inventory_2_outlined, 'color': 0xFFFC7753, 'bg': 0xFFFFF3EE},
      {'label': 'Auto', 'icon': Icons.electric_rickshaw_outlined, 'color': 0xFF2EB086, 'bg': 0xFFEAF8F3},
      {'label': 'Cab \nEconomy', 'icon': Icons.directions_car_outlined, 'color': 0xFFDCA93F, 'bg': 0xFFFDF7EA},
      {'label': 'Bike', 'icon': Icons.two_wheeler_outlined, 'color': 0xFFDCA93F, 'bg': 0xFFFDF7EA},
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              TextButton(
                onPressed: _showAllServicesBottomSheet,
                child: const Text('SEE ALL', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: services.map((s) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (s['label'] == 'Parcel') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ParcelBookingScreen()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => SearchDestinationScreen(isParcel: false, preselectedService: (s['label'] as String).replaceAll('\n', '')),
                      ));
                    }
                  },
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: Color(s['bg'] as int),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s['icon'] as IconData, color: Color(s['color'] as int), size: 22),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(s['label'] as String, 
                            textAlign: TextAlign.center, 
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.1)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouSection() {
    final promos = [
      {'tag': 'SAVE BIG', 'title': 'Bike rides from ₹9', 'tagBg': 0xFFFFB300, 'tagText': 0xFFFFFFFF, 'icon': Icons.two_wheeler_outlined, 'bg': 0xFFFFF8E1},
      {'tag': 'PROMO', 'title': '25% Trip\ndiscounts', 'tagBg': 0xFF2D68FF, 'tagText': 0xFFFFFFFF, 'icon': Icons.card_giftcard_outlined, 'bg': 0xFFF0F4FF},
      {'tag': 'NEW USER', 'title': 'First ride\nfree', 'tagBg': 0xFF00E676, 'tagText': 0xFFFFFFFF, 'icon': Icons.local_activity_outlined, 'bg': 0xFFE8FDF0},
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('For You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen())),
                  child: const Text('SEE ALL', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: promos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final p = promos[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen())),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Color(p['bg'] as int),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(p['tagBg'] as int),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(p['tag'] as String,
                              style: TextStyle(color: Color(p['tagText'] as int), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Text(p['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3))),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                              child: Icon(p['icon'] as IconData, size: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntercityBanner() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IntercityScreen())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 260,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&h=400&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.5), Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('INTERCITY RIDES',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Travel across\nthe city with\ncomfort',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                    const SizedBox(height: 6),
                    const Text('Starting at just ₹289', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IntercityScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoPlaces() {
    final places = [
      {'title': 'Airport', 'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=500&h=300&fit=crop'},
      {'title': 'Station', 'image': 'https://images.unsplash.com/photo-1542708993627-b6e5bbae43c4?w=500&h=300&fit=crop'},
      {'title': 'Office', 'image': 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=500&h=300&fit=crop'},
      {'title': 'Mall', 'image': 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=500&h=300&fit=crop'},
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Go Places', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = places[i];
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(p['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      p['title']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetterAccuracy() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primary,
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFE5E5EA),
            offset: Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             width: 48,
             height: 48,
             decoration: BoxDecoration(
               color: AppColors.primary,
               borderRadius: BorderRadius.circular(12),
             ),
             child: const Icon(Icons.track_changes, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Better Accuracy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Share your precise location so drivers can find you easily without calls.',
                  style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllServicesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final double itemWidth = (MediaQuery.of(context).size.width - 40 - 24) / 3;
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('All Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF0F0F0), height: 1),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  children: [
                    _buildServiceGridItem('Parcel', Icons.inventory_2_outlined, 0xFFFC7753, 0xFFFFF3EE, itemWidth),
                    _buildServiceGridItem('Auto', Icons.electric_rickshaw_outlined, 0xFF2EB086, 0xFFEAF8F3, itemWidth),
                    _buildServiceGridItem('Cab Economy', Icons.directions_car_outlined, 0xFFDCA93F, 0xFFFDF7EA, itemWidth),
                    _buildServiceGridItem('Bike', Icons.two_wheeler_outlined, 0xFFDCA93F, 0xFFFDF7EA, itemWidth),
                    _buildBikeLiteItem(itemWidth),
                    _buildPremiumItem('Cab Premium', Icons.auto_awesome, itemWidth),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceGridItem(String label, IconData icon, int color, int bg, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (label == 'Parcel') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ParcelBookingScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SearchDestinationScreen(isParcel: false, preselectedService: label)));
        }
      },
      child: Container(
        width: width,
        height: 105,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: Color(bg), shape: BoxShape.circle),
              child: Icon(icon, color: Color(color), size: 22),
            ),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeLiteItem(double width) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchDestinationScreen(preselectedService: 'Bike Lite')));
      },
      child: Container(
        width: width,
        height: 105,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(color: Color(0xFFEAF8F3), shape: BoxShape.circle),
                  child: const Icon(Icons.two_wheeler_outlined, color: Color(0xFF2EB086), size: 22),
                ),
                Positioned(
                  top: 0, right: -4,
                  child: Container(
                    width: 14, height: 14,
                    decoration: const BoxDecoration(color: Color(0xFF2EB086), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Bike Lite', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumItem(String label, IconData icon, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchDestinationScreen(preselectedService: label)));
      },
      child: Container(
        width: width,
        height: 105,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: const Color(0xFF323B59).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
          gradient: const LinearGradient(
            colors: [Color(0xFF4A5576), Color(0xFF262A4A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
