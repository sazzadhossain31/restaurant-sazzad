import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart' as app;
import '../theme/app_theme.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool signUp;
  const AuthScreen({super.key, this.signUp = false});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidden = true;
  bool _resetting = false;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<app.AuthProvider>();
    final ok = widget.signUp
        ? await auth.signUp(_email.text.trim(), _password.text)
        : await auth.signIn(_email.text.trim(), _password.text);
    if (!mounted) return;
    if (ok && widget.signUp) Navigator.pop(context);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Unable to sign in. Please try again.',
          ),
        ),
      );
    }
  }

  Future<void> _reset() async {
    if (!_email.text.trim().contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email address first.')),
      );
      return;
    }
    setState(() => _resetting = true);
    var message =
        'If an account exists, a password reset email will arrive shortly.';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _email.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      message = e.message ?? 'Could not send the reset email.';
    } catch (_) {
      message = 'Could not send the reset email. Please try again.';
    }
    if (!mounted) return;
    setState(() => _resetting = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<app.AuthProvider>().isLoading;
    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 430),
      child: AutofillGroup(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppTheme.ink,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Text(
                      'SAVORIA',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 54),
              Text(
                widget.signUp
                    ? 'Join Savoria.\nTaste extraordinary.'
                    : 'Welcome back,\nfood connoisseur.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                widget.signUp
                    ? 'One account. A whole world of artisanal dining waiting for you.'
                    : 'Your curated bites, dining bag, and chef specials await.',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _email,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (v) =>
                    v != null &&
                        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())
                    ? null
                    : 'Enter a valid email address.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                autofillHints: [
                  widget.signUp
                      ? AutofillHints.newPassword
                      : AutofillHints.password,
                ],
                obscureText: _hidden,
                onFieldSubmitted: (_) {
                  if (!widget.signUp && !busy) _submit();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _hidden ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (v) => v == null || v.length < 6
                    ? 'Use at least 6 characters.'
                    : null,
              ),
              if (widget.signUp) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirm,
                  obscureText: _hidden,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  onFieldSubmitted: (_) {
                    if (!busy) _submit();
                  },
                  validator: (v) =>
                      v != _password.text ? 'Passwords do not match.' : null,
                ),
              ] else
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: busy || _resetting ? null : _reset,
                    child: Text(_resetting ? 'Sending…' : 'Forgot password?'),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: busy ? null : _submit,
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.signUp ? 'Create account' : 'Sign in',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    widget.signUp
                        ? 'Already a member of Savoria?'
                        : 'New to Savoria?',
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () {
                            if (widget.signUp) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            }
                          },
                    child: Text(
                      widget.signUp ? 'Sign in' : 'Create an account',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1E), Color(0xFF0D0D0F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 850;
              return Row(
                children: [
                  if (wide)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1F00), Color(0xFF1A1000)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: AppTheme.orange.withValues(alpha: .15),
                          ),
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                top: 40,
                                child: Icon(
                                  Icons.circle,
                                  size: 180,
                                  color: AppTheme.orange.withValues(alpha: .08),
                                ),
                              ),
                              Positioned(
                                left: -30,
                                bottom: 10,
                                child: Icon(
                                  Icons.circle,
                                  size: 130,
                                  color: AppTheme.lime.withValues(alpha: .08),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 82,
                                    height: 82,
                                    decoration: BoxDecoration(
                                      color: AppTheme.orange,
                                      borderRadius: BorderRadius.circular(27),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant_menu_rounded,
                                      size: 46,
                                      color: AppTheme.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 46),
                                  const Text(
                                    'Pure flavor.\nArtisan craft.',
                                    style: TextStyle(
                                      fontSize: 56,
                                      height: 1.08,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -3,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Your table is ready. Discover signature dishes from master kitchens,\ncurate your favorites, and enjoy effortless dining.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.6,
                                      color: Color(0xFFB0A080),
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.orange.withValues(alpha: .12),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppTheme.orange.withValues(alpha: .25),
                                      ),
                                    ),
                                    child: const Text(
                                      '✦  ARTISANAL DINING, EVERY DAY',
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(wide ? 48 : 24),
                      child: Center(child: form),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
