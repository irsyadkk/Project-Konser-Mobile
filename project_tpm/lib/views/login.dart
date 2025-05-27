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
    final data = {
      'email': _emailController.text,
      'pass': _passwordController.text,
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminPage()),
    );
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

  // void _login() {
  //   String username = _usernameController.text.trim();
  //   String password = _passwordController.text;

  //   if (username == '.' && password == '.') {
  //     setState(() => _errorText = '');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const AdminPage()),
  //     );
  //   } else if (username == 'u' && password == 'u') {
  //     setState(() => _errorText = '');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //     );
  //   } else {
  //     setState(() => _errorText = 'XXX Username atau Password salah! XXX');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
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
                      Text(_errormsg!,
                          style: TextStyle(color: Colors.redAccent)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loginHandler,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff7c846),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Login',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Text('Belum punya akun? '),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DaftarPage()),
                          );
                        },
                        child: Text('Daftar dulu aja',
                            style: TextStyle(color: Colors.blue)),
                      ),
                      _errormsg != null
                          ? Center(child: Text("Error $_errormsg"))
                          : Text("Success")
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
