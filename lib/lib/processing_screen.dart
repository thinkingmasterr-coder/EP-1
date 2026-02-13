// File: lib/processing_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'amount_experiments.dart';
import 'user_data.dart';
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

  // Audio Player Instance
  final AudioPlayer _audioPlayer = AudioPlayer();

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

    // --- FIXED AUDIO LOGIC ---
    // Use the main _audioPlayer instance.
    // Do NOT create a new one and do NOT dispose it here.
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
    _audioPlayer.dispose(); // Player is properly disposed here when screen closes
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
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0, left: 0),
                child: const Text(
                    AmountExperiments.currencySymbol,
                    style: AmountExperiments.currencyStyle
                ),
              ),
              const SizedBox(width: 2),

              Text(
                widget.amount,
                textAlign: TextAlign.center,
                style: AmountExperiments.inputAmountStyle,
              ),

              const Padding(
                padding: EdgeInsets.only(top: 17.0, left: 0.0),
                child: Text(
                  '.00',
                  style: AmountExperiments.currencyStyle,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),
        const Text("Successfully Sent to", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,)),

        const SizedBox(height: 30),

        // 3. AVATAR
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF00AA4F), width: 1.5),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.contactName.isNotEmpty ? widget.contactName[0].toUpperCase() : "U",
            style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),

        const SizedBox(height: 15),

        // 4. NAME & NUMBER
        Text(
          widget.contactName,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Left
            Image.asset('assets/EP_logo.webp', width: 25, height: 25),
            // CHANGED: Reduced gap from 5 to 2 to bring it closer
            const SizedBox(width: 2),
            // Number
            Text(widget.contactNumber, style: const TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),

        const SizedBox(height: 40),

        // 5. BOTTOM ACTIONS
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
        // CHANGED: Reduced vertical padding from 8 to 4 to make it much thinner
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        color: Colors.white,
        child: Row(
          children: [
            // CHANGED: Increased container size to 42 for larger icon
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