import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_1/firebase_options.dart';
import 'package:test_1/passwordpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: kIsWeb ? PasswordPage(email: getEmailFromUrl()) : SendEmailLinkPage(),
    );
  }

  
  String getEmailFromUrl() {
    final Uri uri = Uri.base; 
    final email = uri.queryParameters['email']; 
    return email ?? ''; 
  }
}



class SendEmailLinkPage extends StatefulWidget {
  @override
  _SendEmailLinkPageState createState() => _SendEmailLinkPageState();
}

class _SendEmailLinkPageState extends State<SendEmailLinkPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _feedbackMessage = '';

  Future<void> sendEmailLink(String email) async {
    try {
      setState(() {
        _isLoading = true;
        _feedbackMessage = '';
      });
      ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://test1-9fef5.web.app/update-password?email=$email',
        handleCodeInApp: true,
      );
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      setState(() {
        _feedbackMessage = 'Email link sent successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = 'Failed to send email link: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Email Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your email to receive a login link:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        sendEmailLink(email);
                      } else {
                        setState(() {
                          _feedbackMessage =
                              'Please enter a valid email address.';
                        });
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Send Email Link'),
            ),
            const SizedBox(height: 16),
            Text(
              _feedbackMessage,
              style: TextStyle(
                color: _feedbackMessage.startsWith('Failed')
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
