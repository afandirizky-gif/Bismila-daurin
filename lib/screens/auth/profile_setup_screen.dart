import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../state/app_state.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  
  String? _selectedDomisili;
  String? _selectedGender;

  final List<String> _domisiliList = ['Batam', 'Jakarta', 'Surabaya', 'Bandung', 'Medan'];
  final List<String> _genderList = ['Laki-laki', 'Perempuan'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lengkapi Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bantu kami personalisasi pengalamanmu',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textLight, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Avatar and change text
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppTheme.lightMint,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'R',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppTheme.primaryGreen,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Tap untuk ubah foto',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // DOB Date Picker
                _fieldLabel('Tanggal Lahir'),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: _inputDecoration('Pilih Tanggal Lahir').copyWith(
                    suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppTheme.mintGreen),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Tanggal lahir harus dipilih' : null,
                ),
                const SizedBox(height: 20),

                // Domisili Dropdown
                _fieldLabel('Domisili'),
                DropdownButtonFormField<String>(
                  value: _selectedDomisili,
                  hint: const Text('Pilih Domisili'),
                  decoration: _inputDecoration(''),
                  dropdownColor: Colors.white,
                  items: _domisiliList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDomisili = val;
                    });
                  },
                  validator: (value) => value == null ? 'Domisili harus dipilih' : null,
                ),
                const SizedBox(height: 20),

                // Gender Dropdown
                _fieldLabel('Jenis Kelamin'),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text('Pilih Jenis Kelamin'),
                  decoration: _inputDecoration(''),
                  dropdownColor: Colors.white,
                  items: _genderList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedGender = val;
                    });
                  },
                  validator: (value) => value == null ? 'Jenis kelamin harus dipilih' : null,
                ),
                const SizedBox(height: 20),

                // Referral Code (optional)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _fieldLabel('Kode referral'),
                    Text(
                      '(tidak wajib di isi)',
                      style: TextStyle(color: AppTheme.textLight.withOpacity(0.8), fontSize: 12),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _referralController,
                  decoration: _inputDecoration('Dapat kode dari teman?'),
                ),
                const SizedBox(height: 28),

                // Welcome gift banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGold,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard_rounded, color: AppTheme.accentGold, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Profil lengkap = +50 poin selamat datang 🥳',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save profile info to app state
                      appState.updateProfile(
                        name: appState.userName, // Keep default name or update
                        email: appState.userEmail,
                        phone: appState.userPhone,
                        dob: _dobController.text,
                        domisili: _selectedDomisili ?? '',
                        gender: _selectedGender ?? '',
                      );
                      // Navigate to onboarding tour
                      Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
                    }
                  },
                  child: const Text('Simpan Profil'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryGreen,
          fontSize: 14,
        ),
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
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}
