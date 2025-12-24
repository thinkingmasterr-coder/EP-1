// File: lib/processing_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../user_data.dart';
import 'receipt_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String amount;
  final String contactName;
  final String contactNumber;

  const ProcessingScreen({
    super.key,
    required this.amount,
    required this.contactName,
    required this.contactNumber,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  // --- CONFIGURATION ---

  // 1. ZOOM CONTROLS
  final double sendingZoomScale = 3.6;
  final double successZoomScale = 4.0;

  // 2. PERFORMANCE
  final int cacheWidth = 400;

  // 3. ANIMATION DETAILS
  final int sendingTotalFrames = 28;
  final String sendingFolder = 'assets/frames';

  final int confettiTotalFrames = 51;
  final String confettiFolder = 'assets/confetti_frames';

  // --- STATE ---
  int _currentSendingFrame = 1;
  int _currentConfettiFrame = 1;

  bool _showSuccess = false;
  Timer? _animTimer;

  // Cache lists
  final List<ImageProvider> _cachedSendingFrames = [];
  final List<ImageProvider> _cachedConfettiFrames = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareAssets();
    });
  }

  void _prepareAssets() {
    // Load Sending Frames
    for (int i = 1; i <= sendingTotalFrames; i++) {
      String number = i.toString().padLeft(3, '0');
      String path = '$sendingFolder/ezgif-frame-$number.png';
      var provider = ResizeImage(AssetImage(path), width: cacheWidth);
      _cachedSendingFrames.add(provider);
      precacheImage(provider, context);
    }

    // Load Confetti Frames
    for (int i = 1; i <= confettiTotalFrames; i++) {
      String number = i.toString().padLeft(3, '0');
      String path = '$confettiFolder/ezgif-frame-$number.png';
      var provider = ResizeImage(AssetImage(path), width: cacheWidth);
      _cachedConfettiFrames.add(provider);
      precacheImage(provider, context);
    }

    _startSendingFlipbook();
  }

  // --- ANIMATION 1: SENDING ---
  void _startSendingFlipbook() {
    _animTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentSendingFrame < sendingTotalFrames) {
        setState(() {
          _currentSendingFrame++;
        });
      } else {
        _animTimer?.cancel();
        _triggerSuccess();
      }
    });
  }

  Future<void> _triggerSuccess() async {
    double amountDouble = double.tryParse(widget.amount) ?? 0.0;
    UserData.deductBalance(amountDouble);

    setState(() {
      _showSuccess = true;
    });

    // Start the Confetti Animation
    _startConfettiFlipbook();
  }

  // --- ANIMATION 2: CONFETTI ---
  void _startConfettiFlipbook() {
    _animTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_currentConfettiFrame < confettiTotalFrames) {
        setState(() {
          _currentConfettiFrame++;
        });
      } else {
        _animTimer?.cancel(); // Stop at the last frame
      }
    });
  }

  // --- NAVIGATION ACTION (UPDATED) ---
  void _goToReceipt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be tall
      backgroundColor: Colors.transparent, // Transparent for rounded corners
      builder: (context) => ReceiptScreen(
        amount: widget.amount,
        contactName: widget.contactName,
        contactNumber: widget.contactNumber,
      ),
    );
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _showSuccess
          ? _buildSuccessView()
          : _buildSendingView(),
    );
  }

  // --- VIEW 1: SENDING ---
  Widget _buildSendingView() {
    if (_cachedSendingFrames.isEmpty) return const SizedBox();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRect(
            child: Container(
              width: 220,
              height: 140,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 4.8,
                child: Image(
                  image: _cachedSendingFrames[_currentSendingFrame - 1],
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Sending", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Please wait", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  // --- VIEW 2: SUCCESS ---
  Widget _buildSuccessView() {
    return Column(
      children: [
        const SizedBox(height: 80),

        // 1. SCALED & CROPPED ANIMATION
        ClipRect(
          child: Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            child: _cachedConfettiFrames.isNotEmpty
                ? Transform.scale(
              scale: 3.0,
              child: Image(
                image: _cachedConfettiFrames[_currentConfettiFrame - 1],
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            )
                : const SizedBox(),
          ),
        ),

        // 2. AMOUNT
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text("Rs. ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)
            ),
            Text(
                "${widget.amount}.00",
                style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black)
            ),
          ],
        ),

        const SizedBox(height: 5),
        const Text("Successfully Sent to", style: TextStyle(color: Colors.black54, fontSize: 16)),

        const SizedBox(height: 30),

        // 3. AVATAR
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.contactName.isNotEmpty ? widget.contactName[0].toUpperCase() : "U",
            style: const TextStyle(fontSize: 32, color: Color(0xFF00AA4F), fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 15),

        // 4. NAME & NUMBER
        Text(
          widget.contactName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wallet, size: 16, color: Color(0xFF00AA4F)),
            const SizedBox(width: 5),
            Text(widget.contactNumber, style: const TextStyle(color: Colors.black54, fontSize: 16)),
          ],
        ),

        const Spacer(),

        // 5. BOTTOM ACTIONS
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        // VIEW RECEIPT -> Triggers Navigation
        _buildBottomAction(
            icon: Icons.receipt_long,
            text: "View Receipt",
            onTap: _goToReceipt
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        // SHARE -> Placeholder
        _buildBottomAction(
            icon: Icons.share,
            text: "Share",
            onTap: () {
              print("Share clicked");
            }
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.white,
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}