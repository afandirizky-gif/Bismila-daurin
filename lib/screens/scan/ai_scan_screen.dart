import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';
import '../../services/api_service.dart';

class AiScanScreen extends StatefulWidget {
  const AiScanScreen({super.key});

  @override
  State<AiScanScreen> createState() => _AiScanScreenState();
}

class _AiScanScreenState extends State<AiScanScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCategoryIndex = 1; // 0: Organik, 1: Anorganik, 2: B3
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  
  bool _isScanning = false;
  Map<String, dynamic>? _apiResult;

  final List<String> _categories = ['Organik', 'Anorganik', 'B3'];

  // Mock scan results per category
  final List<Map<String, dynamic>> _scanResults = [
    {
      'name': 'Sisa Makanan Organik',
      'accuracy': '89.2% akurat',
      'co2': '0.1 kg',
      'points': 10,
      'instructions': [
        'Pisahkan sisa makanan dari kemasan non-organik.',
        'Masukkan ke dalam komposter jika ada.',
        'Atau masukkan ke kantong sampah organik khusus.',
        'Setorkan ke depo sampah organik terdekat.'
      ],
      'color': AppTheme.organicColor,
    },
    {
      'name': 'Botol Plastik PET',
      'accuracy': '94.5% akurat',
      'co2': '0.3 kg',
      'points': 50,
      'instructions': [
        'Kosongkan dan bilas botol dari sisa cairan.',
        'Lepaskan label dan tutup botol (pisahkan).',
        'Remas botol untuk menghemat ruang.',
        'Masukkan ke tempat sampah anorganik atau drop point terdekat.'
      ],
      'color': AppTheme.anorganicColor,
    },
    {
      'name': 'Baterai Bekas Lithium',
      'accuracy': '91.8% akurat',
      'co2': '0.6 kg',
      'points': 100,
      'instructions': [
        'Jangan dibuang bersama sampah rumah tangga biasa.',
        'Tutup kutub baterai dengan selotip non-konduktif.',
        'Tempatkan dalam wadah plastik kering dan tertutup.',
        'Bawa ke drop point B3 berlisensi terdekat.'
      ],
      'color': AppTheme.b3Color,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scanLineAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      // Ignore initialization errors for now.
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _apiResult = null; // reset
    });

    try {
      final XFile file = await _cameraController!.takePicture();
      final response = await ApiService.uploadImageForScan(file.path);
      
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final result = body['result'];
          final predictedClass = result['predicted_class'];
          final confidence = result['confidence_score'];
          final desc = result['description'] ?? '';
          
          setState(() {
            _apiResult = {
              'name': result['predicted_class_id'] ?? predictedClass,
              'accuracy': '${(confidence * 100).toStringAsFixed(1)}% akurat',
              'co2': predictedClass == 'Organic' ? '0.1 kg' : '0.3 kg',
              'points': predictedClass == 'Organic' ? 10 : 50,
              'instructions': [desc, 'Harap letakkan di tempat yang sesuai.'],
              'color': predictedClass == 'Organic' ? AppTheme.organicColor : AppTheme.anorganicColor,
            };
            
            // Auto-select tab
            if (predictedClass == 'Organic') {
              _selectedCategoryIndex = 0;
            } else if (predictedClass == 'Recyclable') {
              _selectedCategoryIndex = 1;
            }
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('API Error: ${body['error'] ?? 'Unknown error'}')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('HTTP Error ${response.statusCode}: ${response.body}')),
          );
        }
        debugPrint('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Error capture/analyze: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final result = _apiResult;

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Camera Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppTheme.primaryGreen, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'AI Scan Trash',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on_rounded,
                        color: AppTheme.primaryGreen, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Live View Finder viewport (Mock camera)
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Live camera preview
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: _cameraController == null ||
                                !_cameraController!.value.isInitialized
                            ? Container(
                                color: Colors.black87,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: AppTheme.primaryGreen),
                                ),
                              )
                            : CameraPreview(_cameraController!),
                      ),
                    ),

                    // Scanning target overlay bounds
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.8), width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    // Animated scanning line
                    if (!_isScanning)
                      AnimatedBuilder(
                        animation: _scanLineAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: 100 + (_scanLineAnimation.value * 220),
                            child: Container(
                              width: 220,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppTheme.mintGreen,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.mintGreen.withOpacity(0.8),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Capture Button & Loading State
                    Positioned(
                      bottom: 20,
                      child: _isScanning
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(color: AppTheme.mintGreen, strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'AI sedang menganalisa...',
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: _captureAndAnalyze,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Trash category slider pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_categories.length, (index) {
                  final isSelected = index == _selectedCategoryIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppTheme.primaryGreen : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          _categories[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppTheme.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Scan Results Container
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: result == null
                        ? [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40.0),
                                child: Text(
                                  'Silakan arahkan kamera ke sampah dan tekan tombol foto untuk menganalisa secara otomatis menggunakan AI.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.textLight, height: 1.5),
                                ),
                              ),
                            )
                          ]
                        : [
                            // AI Result Title Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'AI Result',
                                      style: TextStyle(
                                          color: AppTheme.textLight, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      result['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppTheme.primaryGreen,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF7F2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    result['accuracy'] as String,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Impact grid
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.creamBg.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('CO2 Dicegah',
                                            style: TextStyle(
                                                color: AppTheme.textLight,
                                                fontSize: 11)),
                                        const SizedBox(height: 4),
                                        Text(result['co2'] as String,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppTheme.primaryGreen)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.creamBg.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Poin Didapat',
                                            style: TextStyle(
                                                color: AppTheme.textLight,
                                                fontSize: 11)),
                                        const SizedBox(height: 4),
                                        Text('+${result['points']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.green)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Handling/Steps Section
                            const Text(
                              'Cara Penanganan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.primaryGreen),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: List.generate(
                                  (result['instructions'] as List).length, (idx) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 9,
                                        backgroundColor: AppTheme.mintGreen,
                                        child: Text('${idx + 1}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          (result['instructions'] as List)[idx],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textDark,
                                              height: 1.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Submit Buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: result == null ? null : () {
                      // Save points to State
                      appState.simulateAiScanResult(
                        _categories[_selectedCategoryIndex],
                        _selectedCategoryIndex == 0
                            ? 0.8
                            : (_selectedCategoryIndex == 1 ? 2.5 : 0.5),
                        result['points'] as int,
                      );

                      // Notify user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Setoran sampah ${result['name']} sukses! +${result['points']} Poin ditambahkan.')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Lanjut Setor'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Hasil kurang tepat? Koreksi manual',
                        style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
