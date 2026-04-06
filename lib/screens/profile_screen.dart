import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
          'Profile',
          style: TextStyle(color: Color(0xFF1A1D1E), fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('ACCOUNT'),
            _menuItem(Icons.person_outline_rounded, 'Personal Info', 'Name, email, phone', const Color(0xFF2D68FF), const Color(0xFFF0F4FF)),
            _menuItem(Icons.payment_outlined, 'Payment Methods', 'Cards, UPI, Wallet', const Color(0xFF2D68FF), const Color(0xFFF0F4FF)),
            _menuItem(Icons.location_on_outlined, 'Saved Places', 'Home, work, gym', const Color(0xFF2D68FF), const Color(0xFFF0F4FF)),
            const SizedBox(height: 20),
            _buildSectionTitle('SETTINGS & PRIVACY'),
            _menuItem(Icons.shield_outlined, 'Privacy & Safety', 'Manage data & sharing', const Color(0xFF2EB086), const Color(0xFFEAF8F3)),
            _menuItem(Icons.settings_outlined, 'App Settings', 'Notifications, language', const Color(0xFF8E8E93), const Color(0xFFF2F2F7)),
            const SizedBox(height: 20),
            _buildSectionTitle('SUPPORT'),
            _menuItem(Icons.help_outline_rounded, 'Help Center', 'FAQs, support chat', const Color(0xFFFC7753), const Color(0xFFFFF3EE)),
            const SizedBox(height: 20),
            _buildRewardsBanner(),
            const SizedBox(height: 20),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF2F2F7), width: 4),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200'),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D68FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Alex Thompson',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1E)),
          ),
          const SizedBox(height: 4),
          const Text(
            'PREMIUM MEMBER',
            style: TextStyle(color: Color(0xFF2D68FF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('4.9', 'RATING'),
              _statItem('128', 'RIDES'),
              _statItem('3Y', 'TENURE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D68FF)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8E8E93), letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8E8E93), letterSpacing: 1.5),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, String sub, Color iconColor, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1E)),
                ),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Color(0xFFF2F2F7), size: 14),
        ],
      ),
    );
  }

  Widget _buildRewardsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D68FF),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Elite Rewards',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'You have 2,450 points',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Redeem',
              style: TextStyle(color: Color(0xFF2D68FF), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFEF),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFFF3B30), size: 20),
            SizedBox(width: 10),
            Text(
              'Logout Account',
              style: TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
