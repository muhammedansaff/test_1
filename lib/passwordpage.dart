import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  const PasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _feedbackMessage = '';

  Future<void> createUserWithEmailPassword() async {
    setState(() {
      _isLoading = true;
      _feedbackMessage = ''; 
    });

    try {
    
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
        _feedbackMessage = 'Account created successfully!';
      });

      
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _feedbackMessage = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email: ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Create New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) {
                // Handle password input if needed
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      final password = _passwordController.text.trim();
                      if (password.isNotEmpty) {
                        createUserWithEmailPassword();
                      } else {
                        setState(() {
                          _feedbackMessage = 'Please enter a valid password.';
                        });
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Account'),
            ),
            const SizedBox(height: 16),
            Text(
              _feedbackMessage,
              style: TextStyle(
                color: _feedbackMessage.startsWith('Error')
                    ? Colors.red
                    : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
