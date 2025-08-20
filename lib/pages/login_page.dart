import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? errorMessage;

  Future<void> signIn() async {
  if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter email and password')),
    );
    return;
  }

  setState(() {
    loading = true;
    errorMessage = null;
  });

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    Navigator.pushReplacementNamed(context, '/home');
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Login failed')),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}

Future<void> signUp() async {
  if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter email and password')),
    );
    return;
  }

  setState(() {
    loading = true;
    errorMessage = null;
  });

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    Navigator.pushReplacementNamed(context, '/home');
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Registration failed')),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 37),),
      centerTitle: true,
      actions: [
        IconButton(
      icon: Icon(Icons.brightness_6),
      onPressed: () {
        Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
      },
    ),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null) ...[
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: emailController,
              decoration:  InputDecoration(labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              )),
            ),
            SizedBox(height: 16,),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password',
              border:OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              )
               ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (!loading)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Sign In'),
                  ),
                  SizedBox(height: 4,),
                  TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/register');
  },
  child: Text('Create Account'),
)

                ],
              ),
          ],
        ),
      ),
    );
  }
}
