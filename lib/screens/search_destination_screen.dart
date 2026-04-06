import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'select_ride_screen.dart';

class SearchDestinationScreen extends StatefulWidget {
  final bool isParcel;
  final String? preselectedService;
  final String? preselectedDestination;

  const SearchDestinationScreen({
    super.key,
    this.isParcel = false,
    this.preselectedService,
    this.preselectedDestination,
  });

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _dropFocus = FocusNode();

  // List of stop controllers (added between pickup and destination)
  final List<TextEditingController> _stopControllers = [];
  final List<FocusNode> _stopFocusNodes = [];

  final _savedPlaces = [
    {'name': 'Home', 'address': 'Koramangala 5th Block, Bangalore', 'icon': Icons.home},
    {'name': 'Work', 'address': 'Electronic City Phase 1, Bangalore', 'icon': Icons.home_repair_service},
  ];

  final _recentPlaces = [
    {'name': 'MG Road Metro Station', 'address': 'MG Road, Bangalore', 'icon': Icons.access_time},
    {'name': 'Phoenix Mall', 'address': 'Whitefield, Bangalore', 'icon': Icons.access_time},
    {'name': 'Cubbon Park', 'address': 'Kasturba Road, Bangalore', 'icon': Icons.access_time},
  ];

  // Track which field to fill when tapping a place
  int _activeFieldIndex = -1; // -1 = drop, 0+ = stop index

  @override
  void initState() {
    super.initState();
    _pickupController.text = 'Current Location';
    if (widget.preselectedDestination != null) {
      _dropController.text = widget.preselectedDestination!;
    }
    _dropController.addListener(() => setState(() {}));
    _pickupController.addListener(() => setState(() {}));
    // When drop field gets focus, set active field to destination
    _dropFocus.addListener(() {
      if (_dropFocus.hasFocus) {
        setState(() => _activeFieldIndex = -1);
      }
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _dropFocus.dispose();
    for (final c in _stopControllers) {
      c.dispose();
    }
    for (final f in _stopFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _addStop() {
    if (_stopControllers.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Maximum 3 stops allowed'),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    final controller = TextEditingController();
    final focusNode = FocusNode();
    final stopIndex = _stopControllers.length;
    controller.addListener(() => setState(() {}));
    // Track focus to know which field is active
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() => _activeFieldIndex = _stopFocusNodes.indexOf(focusNode));
      }
    });
    setState(() {
      _stopControllers.add(controller);
      _stopFocusNodes.add(focusNode);
      _activeFieldIndex = stopIndex; // set new stop as active
    });
    // Focus the newly added stop field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stopControllers[index].dispose();
      _stopFocusNodes[index].dispose();
      _stopControllers.removeAt(index);
      _stopFocusNodes.removeAt(index);
    });
  }

  // Check if all fields are valid
  bool get _allFieldsValid {
    if (_pickupController.text.trim().isEmpty) return false;
    if (_dropController.text.trim().isEmpty) return false;
    // If stops exist, ALL must be filled
    for (final c in _stopControllers) {
      if (c.text.trim().isEmpty) return false;
    }
    return true;
  }

  void _proceed() {
    final pickup = _pickupController.text.trim();
    final drop = _dropController.text.trim();
    if (pickup.isEmpty) {
      _showError('Please enter a pickup location');
      return;
    }
    if (drop.isEmpty) {
      _showError('Please enter a destination');
      return;
    }
    // Validate all stops are filled
    for (int i = 0; i < _stopControllers.length; i++) {
      if (_stopControllers[i].text.trim().isEmpty) {
        _showError('Please enter location for Stop ${i + 1}');
        _stopFocusNodes[i].requestFocus();
        return;
      }
    }
    // All valid - collect stops
    final stops = _stopControllers
        .map((c) => c.text.trim())
        .toList();

    Navigator.push(context, MaterialPageRoute(
      builder: (_) => SelectRideScreen(
        pickup: pickup,
        drop: drop,
        stops: stops,
        isParcel: widget.isParcel,
        preselectedService: widget.preselectedService,
      ),
    ));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _selectPlace(String name, String address) {
    setState(() {
      if (_activeFieldIndex >= 0 && _activeFieldIndex < _stopControllers.length) {
        // Fill the active stop field
        _stopControllers[_activeFieldIndex].text = address;
        // Move focus to next empty field
        _focusNextEmpty();
      } else {
        // Fill the destination field
        _dropController.text = address;
        // If all fields are valid, proceed
        if (_allFieldsValid) {
          Future.delayed(const Duration(milliseconds: 150), () {
            _proceed();
          });
        }
      }
    });
  }

  // Focus the next empty field (stop or destination)
  void _focusNextEmpty() {
    // Check stops first
    for (int i = 0; i < _stopControllers.length; i++) {
      if (_stopControllers[i].text.trim().isEmpty) {
        _stopFocusNodes[i].requestFocus();
        setState(() => _activeFieldIndex = i);
        return;
      }
    }
    // Then check destination
    if (_dropController.text.trim().isEmpty) {
      _dropFocus.requestFocus();
      setState(() => _activeFieldIndex = -1);
      return;
    }
    // All filled - auto proceed
    if (_allFieldsValid) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _proceed();
      });
    }
  }

  void _useCurrentLocation() {
    setState(() {
      _pickupController.text = 'Current Location';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.my_location, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Using your current location'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _dropFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book a Ride',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('Me', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          // Top section with inputs and buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Location inputs with connecting line
                Stack(
                  children: [
                    Column(
                      children: [
                        // Pickup
                        _buildInputBox(
                          controller: _pickupController,
                          hint: 'Pickup location',
                          iconColor: Colors.blue,
                          hasBorder: true,
                        ),
                        // Stop fields (dynamically added)
                        ..._buildStopFields(),
                        const SizedBox(height: 12),
                        // Destination
                        _buildInputBox(
                          controller: _dropController,
                          hint: 'Where to?',
                          iconColor: Colors.red,
                          hasBorder: false,
                          focusNode: _dropFocus,
                          onSubmitted: (_) => _proceed(),
                        ),
                      ],
                    ),
                    // Connecting line between all dots
                    Positioned(
                      left: 20,
                      top: 35,
                      bottom: 35,
                      child: Container(width: 1, color: Colors.grey.shade300),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryButton(
                        label: 'Select on Map',
                        icon: Icons.map_outlined,
                        onPressed: () {
                          setState(() {
                            _dropController.text = 'Brigade Road, Bangalore';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Location selected from map'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSecondaryButton(
                        label: _stopControllers.length >= 3 ? 'Max Stops' : 'Add Stop',
                        icon: _stopControllers.length >= 3 ? Icons.block : Icons.add_circle,
                        onPressed: _addStop,
                        iconColor: _stopControllers.length >= 3 ? Colors.grey : Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Use current location button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _useCurrentLocation,
                    icon: const Icon(Icons.near_me, size: 18),
                    label: const Text('Use Current Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable list of saved/recent places
          Expanded(
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF8F9FA),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text(
                    'SAVED PLACES',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                  ),
                ),
                ..._savedPlaces.map((place) => _buildPlaceItem(place)),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF8F9FA),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text(
                    'RECENT',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                  ),
                ),
                ..._recentPlaces.map((place) => _buildPlaceItem(place, isRecent: true)),
              ],
            ),
          ),

          // Bottom confirm button - only show when all fields are filled
          if (_allFieldsValid)
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Confirm Destination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build dynamic stop input fields
  List<Widget> _buildStopFields() {
    return List.generate(_stopControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _buildStopInputBox(
          controller: _stopControllers[index],
          focusNode: _stopFocusNodes[index],
          hint: 'Stop ${index + 1}',
          index: index,
        ),
      );
    });
  }

  Widget _buildStopInputBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light amber to distinguish stops
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Colors.orange, size: 12),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          // Remove stop button
          GestureDetector(
            onTap: () => _removeStop(index),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    required Color iconColor,
    required bool hasBorder,
    FocusNode? focusNode,
    Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: hasBorder ? Colors.white : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: hasBorder ? Border.all(color: Colors.blue, width: 1.5) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.circle, color: iconColor, size: 12),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => controller.clear()),
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: iconColor ?? Colors.blue),
      label: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildPlaceItem(Map<String, dynamic> place, {bool isRecent = false}) {
    return InkWell(
      onTap: () => _selectPlace(place['name'] as String, place['address'] as String),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isRecent ? Colors.grey.shade100 : AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                place['icon'] as IconData,
                color: isRecent ? Colors.black54 : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place['address'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.north_west, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
