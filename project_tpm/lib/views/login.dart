import 'package:flutter/material.dart';
import 'package:project_tpm/models/user_model.dart';
import 'package:project_tpm/presenters/login_presenter.dart';
import 'package:project_tpm/views/admin.dart';
import 'package:project_tpm/views/daftar.dart';
import 'package:project_tpm/views/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginView {
  late LoginPresenter presenter;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errormsg = '';
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  void loginHandler() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final data = {
      'email': email,
      'pass': password,
    };

    presenter.loginUser('login', data);
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) {
    // Cek email, menentukan page selanjutnya
    if (user.email == "admin@gmail.com") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  void showError(String msg) {
    setState(() {
      _errormsg = msg;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_errormsg != null && _errormsg!.isNotEmpty)
                        Text(_errormsg!,
                            style: const TextStyle(color: Colors.redAccent)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loginHandler,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff7c846),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Login',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.all(24.0)),
                          const Text('Belum punya akun?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DaftarPage()),
                              );
                            },
                            child: const Text('Daftar dulu aja !',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
