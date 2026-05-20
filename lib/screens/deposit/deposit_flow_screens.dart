import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class SetorSampahScreen extends StatefulWidget {
  const SetorSampahScreen({super.key});

  @override
  State<SetorSampahScreen> createState() => _SetorSampahScreenState();
}

class _SetorSampahScreenState extends State<SetorSampahScreen> {
  int _viewIndex = 0; 
  // 0: Choice View (Page 20)
  // 1: Drop Point Map (Page 21)
  // 2: Jemput Calendar (Page 22)
  // 3: Jadwal Aktif (Page 23)
  // 4: Jadwal Penjemputan Baru (Page 24)
  // 5: Drop Point Navigation Detail (Page 31)

  // Selected Drop point holder
  Map<String, dynamic>? _selectedDropPoint;

  // New pickup scheduler fields
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _timeSlots = ['09:00 - 12:00', '13:00 - 16:00', '16:00 - 19:00'];

  @override
  void dispose() {
    _weightController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _selectedDate = null;
    _selectedTimeSlot = null;
    _weightController.clear();
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: AppBar(
        leading: _viewIndex > 0 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  setState(() {
                    if (_viewIndex == 5) _viewIndex = 1;
                    else if (_viewIndex == 4) _viewIndex = 3;
                    else _viewIndex = 0;
                  });
                },
              )
            : null,
        title: Text(
          _viewIndex == 3 ? 'Jadwal Aktif' : (_viewIndex == 4 ? 'Jadwal Penjemputan Baru' : 'Setor Sampah'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentView(appState),
        ),
      ),
    );
  }

  Widget _buildCurrentView(AppState state) {
    switch (_viewIndex) {
      case 0:
        return _buildChoiceView(state);
      case 1:
        return _buildDropPointMapView(state);
      case 2:
        return _buildJemputCalendarView(state);
      case 3:
        return _buildJadwalAktifView(state);
      case 4:
        return _buildJadwalBaruView(state);
      case 5:
        return _buildDropPointDetailView();
      default:
        return _buildChoiceView(state);
    }
  }

  // --- 0. Choice View (Page 20) ---
  Widget _buildChoiceView(AppState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      children: [
        const Text(
          'Pilih cara setor yang paling mudah untukmu',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textLight, fontSize: 14),
        ),
        const SizedBox(height: 24),
        
        // Jemput & Drop Point buttons
        Row(
          children: [
            Expanded(
              child: _choiceCard(
                icon: Icons.inventory_2_rounded,
                title: 'Jemput',
                desc: 'Kurir datang ke rumah',
                onTap: () {
                  setState(() {
                    // Check if there are active pickups. If yes, show active schedule. Else calendar list
                    if (state.pickups.isNotEmpty) {
                      _viewIndex = 3;
                    } else {
                      _viewIndex = 2;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _choiceCard(
                icon: Icons.location_on_rounded,
                title: 'Drop Point',
                desc: 'Setor mandiri di stasiun',
                onTap: () => setState(() => _viewIndex = 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Recent Deposits
        Row(
          children: [
            const Icon(Icons.history_rounded, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'Recent Deposits',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: state.recentDeposits.map((item) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    Text(
                      item.type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: _getTrashColor(item.type),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.weight} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.relativeTime,
                      style: const TextStyle(color: AppTheme.textLight, fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
        Center(
          child: Text(
            'Pilih metode penyetoran untuk melanjutkan',
            style: TextStyle(color: AppTheme.textLight, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _choiceCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightMint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryGreen, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrashColor(String type) {
    if (type.contains('Plastic')) return AppTheme.anorganicColor;
    if (type.contains('Paper')) return AppTheme.organicColor;
    if (type.contains('Metal')) return Colors.orange;
    return AppTheme.mintGreen;
  }

  // --- 1. Drop Point Map View (Page 21) ---
  Widget _buildDropPointMapView(AppState state) {
    final List<Map<String, dynamic>> dropPoints = [
      {
        'name': 'EcoHub Batam Center',
        'address': 'Jl. Engku Putri No. 15',
        'distance': '0.8 km',
        'rating': '4.8',
        'hours': '08:00 - 20:00',
        'status': 'Buka',
        'eta': '3 min',
        'points': '+150 pts',
      },
      {
        'name': 'Recycle Station Harbour Bay',
        'address': 'Harbour Bay Residences',
        'distance': '2.5 km',
        'rating': '4.9',
        'hours': '10:00 - 18:00',
        'status': 'Tutup',
        'eta': '8 min',
        'points': '+200 pts',
      },
    ];

    return Column(
      children: [
        // Selection cards choice header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _viewIndex = 2),
                  child: const Text('Jemput'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Drop Point'),
                ),
              ),
            ],
          ),
        ),

        // Map Graphic Mockup
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4EAD6).withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Custom drawn roads/greenery mock
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GridPaper(
                      color: Colors.green.withOpacity(0.04),
                      divisions: 2,
                      interval: 100,
                      child: Container(),
                    ),
                  ),
                ),
                // Location pins
                const Positioned(
                  top: 80,
                  left: 60,
                  child: Icon(Icons.location_on_rounded, color: Colors.green, size: 36),
                ),
                const Positioned(
                  bottom: 120,
                  right: 90,
                  child: Icon(Icons.location_on_rounded, color: Colors.red, size: 36),
                ),
                // Current User location
                Positioned(
                  top: 150,
                  left: 140,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.blue, size: 10),
                        SizedBox(width: 6),
                        Text('Lokasi Kamu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                // Floating target button
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryGreen,
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Drop Points List
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Drop Point Terdekat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen)),
                  Text('${dropPoints.length} lokasi', style: const TextStyle(color: AppTheme.textLight, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: dropPoints.map((dp) {
                  final isOpen = dp['status'] == 'Buka';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.lightMint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded, color: AppTheme.mintGreen),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dp['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              dp['status'] as String,
                              style: TextStyle(
                                color: isOpen ? Colors.green : Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dp['address'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.near_me_outlined, size: 12, color: AppTheme.mintGreen),
                              const SizedBox(width: 4),
                              Text('${dp['distance']} • ', style: const TextStyle(fontSize: 11)),
                              const Icon(Icons.star_rounded, size: 12, color: AppTheme.accentGold),
                              Text(' ${dp['rating']} • ', style: const TextStyle(fontSize: 11)),
                              const Icon(Icons.access_time_rounded, size: 12, color: AppTheme.textLight),
                              Text(' ${dp['hours']}', style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDropPoint = dp;
                          _viewIndex = 5; // Detail navigation view
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 2. Jemput Calendar View (Page 22) ---
  Widget _buildJemputCalendarView(AppState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      children: [
        // Selection cards choice header
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Jemput'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _viewIndex = 1),
                child: const Text('Drop Point'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        const Text(
          'Jadwal Penjemputan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen),
        ),
        const SizedBox(height: 12),

        // Available slots dates
        _scheduleSlotTile('Senin, 31 Maret', 'Slot: 09:00 - 12:00'),
        _scheduleSlotTile('Selasa, 1 April', 'Slot: 13:00 - 16:00'),
        _scheduleSlotTile('Rabu, 2 April', 'Slot: 09:00 - 12:00'),
        const SizedBox(height: 24),

        // Recents
        const Text(
          'Recent Deposits',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryGreen),
        ),
        const SizedBox(height: 12),
        // Small deposits scroll
        Container(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: state.recentDeposits.map((item) {
              return Container(
                width: 110,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text('${item.weight} kg', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.mintGreen)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 36),

        ElevatedButton(
          onPressed: () {
            _resetForm();
            setState(() {
              _viewIndex = 4; // Create Form view
            });
          },
          child: const Text('Buat Jadwal Baru'),
        ),
      ],
    );
  }

  Widget _scheduleSlotTile(String day, String slot) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(slot, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.lightMint,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Available', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        onTap: () {
          // Pre-fill form from selected slot
          _selectedDate = DateTime(2026, 3, 31);
          _selectedTimeSlot = '09:00 - 12:00';
          _addressController.text = 'Jl. Melati No. 15, Jakarta Selatan';
          _weightController.text = '8.0';
          setState(() {
            _viewIndex = 4;
          });
        },
      ),
    );
  }

  // --- 3. Jadwal Aktif View (Page 23) ---
  Widget _buildJadwalAktifView(AppState state) {
    final activeList = state.pickups;
    if (activeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_rounded, size: 60, color: AppTheme.textLight),
            const SizedBox(height: 16),
            const Text('Tidak ada jadwal aktif.', style: TextStyle(color: AppTheme.textLight)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _viewIndex = 4),
              child: const Text('+ Buat Jadwal Baru'),
            ),
          ],
        ),
      );
    }

    final pickup = activeList.first; // Show the first active pickup details

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Terjadwal',
                        style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      onPressed: () {
                        state.cancelPickup(pickup.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Jadwal penjemputan berhasil dibatalkan.')),
                        );
                        setState(() {
                          _viewIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Date/Time
                _detailRow(Icons.calendar_month_rounded, 'Tanggal & Waktu', 
                    '${pickup.date.day} ${_getMonthName(pickup.date.month)} ${pickup.date.year}, ${pickup.timeSlot}'),
                const Divider(height: 24),

                // Location
                _detailRow(Icons.location_on_rounded, 'Lokasi', pickup.address),
                const Divider(height: 24),

                // Estimated weight
                _detailRow(Icons.shopping_bag_rounded, 'Estimasi Berat', '${pickup.estimatedWeight} kg'),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pre-populate form to modify
                      _selectedDate = pickup.date;
                      _selectedTimeSlot = pickup.timeSlot;
                      _weightController.text = pickup.estimatedWeight.toString();
                      _addressController.text = pickup.address;
                      setState(() {
                        _viewIndex = 4;
                      });
                    },
                    child: const Text('Ubah Jadwal'),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              _resetForm();
              setState(() {
                _viewIndex = 4;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('+ Buat Jadwal Baru'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.mintGreen, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textLight, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryGreen)),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. Jadwal Penjemputan Baru View (Page 24) ---
  Widget _buildJadwalBaruView(AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Select Date
          _formLabel('Pilih Tanggal'),
          TextFormField(
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            decoration: _inputDecoration('Pilih Tanggal').copyWith(
              suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppTheme.mintGreen),
            ),
            controller: TextEditingController(
              text: _selectedDate != null 
                  ? '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} ${_selectedDate!.year}'
                  : '',
            ),
          ),
          const SizedBox(height: 16),

          // Select Time Slot
          _formLabel('Pilih Waktu'),
          DropdownButtonFormField<String>(
            value: _selectedTimeSlot,
            hint: const Text('Pilih Slot Waktu'),
            decoration: _inputDecoration(''),
            items: _timeSlots.map((slot) {
              return DropdownMenuItem(value: slot, child: Text(slot));
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedTimeSlot = val;
              });
            },
          ),
          const SizedBox(height: 16),

          // Weight
          _formLabel('Estimasi Berat (kg)'),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Masukkan berat dalam kg').copyWith(
              suffixIcon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.mintGreen),
            ),
          ),
          const SizedBox(height: 16),

          // Address
          _formLabel('Alamat Penjemputan'),
          TextFormField(
            controller: _addressController,
            maxLines: 3,
            decoration: _inputDecoration('Masukkan alamat lengkap...').copyWith(
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.mintGreen),
            ),
          ),
          const SizedBox(height: 32),

          // Confirm Button
          ElevatedButton(
            onPressed: () {
              if (_selectedDate == null || _selectedTimeSlot == null || _weightController.text.isEmpty || _addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mohon isi semua data formulir')),
                );
                return;
              }
              
              final weight = double.tryParse(_weightController.text) ?? 5.0;
              state.schedulePickup(
                _selectedDate!,
                _selectedTimeSlot!,
                _addressController.text,
                weight,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jadwal penjemputan berhasil disimpan!')),
              );

              setState(() {
                _viewIndex = 3; // Go back to active pickups detailed card view
              });
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.white),
                SizedBox(width: 10),
                Text('Konfirmasi Jadwal'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  // --- 5. Drop Point Detail Navigation (Page 31) ---
  Widget _buildDropPointDetailView() {
    if (_selectedDropPoint == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Map Placeholder at the top
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD4EAD6).withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.map_rounded, size: 64, color: AppTheme.mintGreen),
                  Positioned(
                    top: 40,
                    child: Text('Simulasi Peta Rute Navigasi', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Detail Title Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.lightMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded, color: AppTheme.mintGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDropPoint!['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen),
                          ),
                          Text(
                            _selectedDropPoint!['address'],
                            style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Specs Grid (Distance, ETA, Reward)
                Row(
                  children: [
                    _navigationCard(Icons.near_me_rounded, 'Distance', _selectedDropPoint!['distance'], Colors.blue),
                    const SizedBox(width: 8),
                    _navigationCard(Icons.access_time_filled_rounded, 'ETA', _selectedDropPoint!['eta'], Colors.orange),
                    const SizedBox(width: 8),
                    _navigationCard(Icons.monetization_on_rounded, 'Reward', _selectedDropPoint!['points'], Colors.green),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navigasi rute dimulai! Silakan ikuti petunjuk di jalan.')),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigation_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Start Navigation'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.creamBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: AppTheme.textLight, fontSize: 10)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryGreen)),
          ],
        ),
      ),
    );
  }
}
