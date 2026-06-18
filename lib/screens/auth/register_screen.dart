import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import 'package:flutter/gestures.dart';
import 'terms_and_conditions_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.creamBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: AppTheme.primaryGreen),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Buat Akun Daurin',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai berkontribusi untuk lingkungan.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color.fromARGB(255, 42, 36, 36),
                          height: 1.5,
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 32),
                  _fieldLabel('Username'),
                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Masukkan Username'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Username tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Password'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration('Masukkan Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.textLight,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.trim().length < 6
                            ? 'Password minimal 6 karakter'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Konfirmasi Password'),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: _inputDecoration('Masukkan Password'),
                    validator: (value) {
                      if (value != _passwordController.text)
                        return 'Password tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Email'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Masukkan Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Email tidak boleh kosong';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) return 'Email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Nomor Handphone'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Masukkan Nomor Handphone'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nomor Handphone tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (val) =>
                            setState(() => _agreeToTerms = val ?? false),
                        activeColor: AppTheme.primaryGreen,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Saya setuju dengan ',
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 29, 27, 27)),
                            children: [
                              TextSpan(
                                text: 'Syarat & Ketentuan',
                                style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TermsAndConditionsScreen()));
                                  },
                              ),
                              const TextSpan(text: ' dan '),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("Kebijakan Privasi diklik");
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _agreeToTerms) {
                      final data = {
                        'fullName': _usernameController.text.trim(),
                        'email': _emailController.text.trim(),
                        'password': _passwordController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        'address': '-', // Dummy address for now
                      };

                      final result = await AuthService.register(data);
                      if (!mounted) return;

                      if (result['success']) {
                        final user = result['user'];
                        Provider.of<AppState>(context, listen: false).setUserData(user);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main_frame',
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    } else if (!_agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Anda harus menyetujui Syarat & Ketentuan')),
                      );
                    }
                  },
                  child: const Text('Daftar Sekarang'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        )
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
      hintText: hint,
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
