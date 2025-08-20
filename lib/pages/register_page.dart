import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
  if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter email and password")),
    );
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    print(" Registered Successfully: ${userCredential.user!.email}");
    Navigator.pushReplacementNamed(context, '/home');
  } on FirebaseAuthException catch (e) {
    print(" Registration Failed: ${e.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Registration Failed")),
    );
  } catch (e) {
    print(" Registration Failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration Failed: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("Register"),
  actions: [
    IconButton(
     icon: Icon(Icons.brightness_6),
     onPressed:(){
      Provider.of<ThemeNotifier>(context,listen: false).toggleTheme();
     },)
  ],
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration:  InputDecoration(labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              )),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: passwordController,
              decoration:  InputDecoration(labelText: "Password",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
