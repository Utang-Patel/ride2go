import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _offers = [
    {
      'tag': 'SAVE BIG',
      'title': 'Bike rides from ₹9',
      'desc': 'Book any bike ride and pay just ₹9 for your first 3 rides this week.',
      'code': 'BIKE9',
      'expiry': 'Expires Apr 5, 2026',
      'tagBg': 0xFFE8F5E9, 'tagText': 0xFF2E7D32, 'accent': 0xFF4CAF50,
    },
    {
      'tag': 'PROMO',
      'title': '25% Trip discounts',
      'desc': 'Get 25% off on all cab rides. Maximum discount of ₹75 per ride.',
      'code': 'TRIP25',
      'expiry': 'Expires Apr 10, 2026',
      'tagBg': 0xFFE3F2FD, 'tagText': 0xFF1565C0, 'accent': 0xFF2196F3,
    },
    {
      'tag': 'NEW USER',
      'title': 'First ride free',
      'desc': 'New to ride2go? Your first ride is completely free up to ₹150.',
      'code': 'FIRSTFREE',
      'expiry': 'Expires Dec 31, 2026',
      'tagBg': 0xFFFFF3E0, 'tagText': 0xFFE65100, 'accent': 0xFFFF9800,
    },
    {
      'tag': 'WEEKEND',
      'title': 'Weekend special 30% off',
      'desc': 'Enjoy 30% off on all rides every Saturday and Sunday.',
      'code': 'WEEKEND30',
      'expiry': 'Every weekend',
      'tagBg': 0xFFF3E5F5, 'tagText': 0xFF6A1B9A, 'accent': 0xFF9C27B0,
    },
    {
      'tag': 'REFERRAL',
      'title': 'Refer & earn ₹100',
      'desc': 'Refer a friend and earn ₹100 ride credits when they complete their first ride.',
      'code': 'REFER100',
      'expiry': 'No expiry',
      'tagBg': 0xFFE8EAF6, 'tagText': 0xFF283593, 'accent': 0xFF3F51B5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Offers & Promos'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _offers.length,
        itemBuilder: (_, i) => _offerCard(context, _offers[i]),
      ),
    );
  }

  Widget _offerCard(BuildContext context, Map offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Color(offer['accent'] as int),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(offer['tagBg'] as int),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(offer['tag'] as String,
                          style: TextStyle(color: Color(offer['tagText'] as int), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Text(offer['expiry'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(offer['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(offer['desc'] as String, style: const TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.4)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer_outlined, size: 16, color: Color(offer['accent'] as int)),
                            const SizedBox(width: 8),
                            Text(offer['code'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Code "${offer['code']}" copied!'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(offer['accent'] as int),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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
