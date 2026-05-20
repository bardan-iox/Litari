import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_logo.dart';
import 'pilih_bahasa_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLanjut() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PilihBahasaScreen(),
      ),
    );
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

                // Logo + App Name
                const LitariLogo(showName: true),

                const SizedBox(height: 40),

                // Input Card
                _LoginCard(
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),

                const SizedBox(height: 20),

                // Lanjut button
                _LanjutButton(onPressed: _onLanjut),

                const SizedBox(height: 20),

                // Lupa kata sandi
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'LUPA KATA SANDI',
                    style: AppTextStyles.link,
                  ),
                ),

                const SizedBox(height: 48),

                // Social login
                _SocialLoginRow(),

                const SizedBox(height: 20),

                // Terms text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Dengan masuk ke Nusantara talk, kamu menyetujui Ketentuan dan Kebijakan Privasi kami.',
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

class _LoginCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const _LoginCard({
    required this.usernameController,
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
          // Username field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: usernameController,
              style: AppTextStyles.inputText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Username / Email',
                hintStyle: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),

          // Divider
          Divider(height: 1, thickness: 1, color: AppColors.inputBorder),

          // Password field
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
                  color: AppColors.textHint,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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

class _LanjutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LanjutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Lanjut',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _FacebookIcon(),
                SizedBox(width: 8),
                Text(
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
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _GoogleIcon(),
                SizedBox(width: 8),
                Text(
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

// Facebook icon using CustomPainter
class _FacebookIcon extends StatelessWidget {
  const _FacebookIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.facebookBlue,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// Google "G" icon
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _GoogleIconPainter(),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Draw the 4 colored arcs of Google G
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Red top-right
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r - 2),
      -1.0, 1.4, false, paint,
    );

    // Yellow bottom-right
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r - 2),
      0.4, 1.2, false, paint,
    );

    // Green bottom-left
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r - 2),
      1.6, 1.2, false, paint,
    );

    // Blue top-left
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r - 2),
      2.8, 1.2, false, paint,
    );

    // Horizontal bar of G
    paint
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(cx, cy - 0.5),
      Offset(cx + r - 2, cy - 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
