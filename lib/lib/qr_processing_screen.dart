// File: lib/qr_processing_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; // <--- IMPORT THIS
import 'package:intl/intl.dart';
import 'user_data.dart';
import 'qr_receipt_screen.dart';

class QrProcessingScreen extends StatefulWidget {
  final String amount;
  final String recipientName;
  final String recipientLocation;

  const QrProcessingScreen({
    super.key,
    required this.amount,
    required this.recipientName,
    required this.recipientLocation,
  });

  @override
  State<QrProcessingScreen> createState() => _QrProcessingScreenState();
}

class _QrProcessingScreenState extends State<QrProcessingScreen> {
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

  // Audio Player Instance
  final AudioPlayer _audioPlayer = AudioPlayer(); // <--- NEW PLAYER

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

    // PLAY SOUND
    try {
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }

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

  // --- NAVIGATION ACTION ---
  void _goToReceipt() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return QrReceiptScreen(
          amount: widget.amount,
          storeName: widget.recipientName,
        );
      },
    );
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    _audioPlayer.dispose(); // <--- DISPOSE PLAYER
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _showSuccess ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          )
        ],
        automaticallyImplyLeading: false,
      ) : null,
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
    final formatCurrency = NumberFormat('#,##0');
    return Column(
      children: [
        const SizedBox(height: 10),

        // 1. Confetti (Smaller & Zoomed In)
        ClipRect(
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: _cachedConfettiFrames.isNotEmpty
                ? Transform.scale(
              scale: successZoomScale,
              child: Image(
                image: _cachedConfettiFrames[_currentConfettiFrame - 1],
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            )
                : const SizedBox(),
          ),
        ),

        const SizedBox(height: 10),

        // 2. Amount Area
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns Rs to top
            children: [
              // Rs. Exponent Style
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Text("Rs.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 4),

              // Main Amount
              Text(
                formatCurrency.format(double.tryParse(widget.amount) ?? 0.0),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, height: 1.2),
              ),

              // .00 Exponent Style
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 2.0),
                child: Text(
                  '.00',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),
        const Text("Successfully Paid to", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,)),

        // Height from your previous edit
        const SizedBox(height: 60),

        // 3. QR Code Image Asset
        SizedBox(
          height: 80,
          width: 80,
          child: Image.asset('assets/qr_code1.png'),
        ),

        const SizedBox(height: 15),

        // 4. Name (Bigger)
        Text(
          widget.recipientName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 5),

        // 5. Location (Darker)
        Text(
            widget.recipientLocation,
            style: const TextStyle(color: Colors.black87, fontSize: 16)
        ),

        const SizedBox(height: 40),

        // Buttons
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        _buildBottomAction(
            icon: Image.asset('assets/reciept_img.png'),
            text: "View Receipt",
            onTap: _goToReceipt
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        _buildBottomAction(
            icon: const Icon(Icons.share, color: Colors.black54),
            text: "Share",
            onTap: () {
              print("Share clicked");
            }
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        const Spacer(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottomAction({
    required Widget icon,
    required String text,
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // CHANGED: Reduced vertical padding from 16 to 4 (Thinner)
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        color: Colors.white,
        child: Row(
          children: [
            // CHANGED: Increased size from 35 to 42 (Bigger Icon/Image)
            SizedBox(width: 42, height: 42, child: icon),
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