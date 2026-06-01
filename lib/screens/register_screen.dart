import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_logo.dart';
import '../services/user_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onDaftar() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Semua field harus diisi');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Kata sandi minimal 6 karakter');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await cred.user?.updateDisplayName(_usernameController.text.trim());
      await UserService.initUser(cred.user!);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = 'Email sudah terdaftar';
            break;
          case 'invalid-email':
            _errorMessage = 'Format email tidak valid';
            break;
          case 'weak-password':
            _errorMessage = 'Kata sandi terlalu lemah';
            break;
          default:
            _errorMessage = 'Registrasi gagal, coba lagi';
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onGoogleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await UserService.initUser(cred.user!);
    } catch (e) {
      setState(() => _errorMessage = 'Daftar dengan Google gagal, coba lagi');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const LitariLogo(showName: true),
                const SizedBox(height: 32),
                _RegisterCard(
                  usernameController: _usernameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style:
                          const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.primary)
                    : _DaftarButton(onPressed: _onDaftar),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: AppTextStyles.bodySecondary,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('Masuk', style: AppTextStyles.link),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _SocialRegisterRow(onGooglePressed: _onGoogleRegister),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Dengan mendaftar ke Litari, kamu menyetujui Ketentuan dan Kebijakan Privasi kami.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const _RegisterCard({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: usernameController,
              style: AppTextStyles.inputText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Username',
                hintStyle:
                    TextStyle(color: AppColors.textHint, fontSize: 16),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.inputBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.inputText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
                hintStyle:
                    TextStyle(color: AppColors.textHint, fontSize: 16),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.inputBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Kata Sandi',
                hintStyle: const TextStyle(
                    color: AppColors.textHint, fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: 26,
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaftarButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _DaftarButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Daftar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SocialRegisterRow extends StatelessWidget {
  final VoidCallback onGooglePressed;
  const _SocialRegisterRow({required this.onGooglePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/Facebook_logo.svg',
                    width: 28, height: 28),
                const SizedBox(width: 8),
                const Text(
                  'facebook',
                  style: TextStyle(
                    color: AppColors.facebookBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _SocialButton(
            onPressed: onGooglePressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/Google_logo.svg',
                    width: 28, height: 28),
                const SizedBox(width: 8),
                const Text(
                  'Google',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _SocialButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: child,
      ),
    );
  }
}