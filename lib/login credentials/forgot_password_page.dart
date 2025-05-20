// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:valuebuyin/components/my_button.dart';
// import 'package:valuebuyin/components/my_textfield.dart';
// import 'package:valuebuyin/components/square_tile.dart';
// import 'package:valuebuyin/login%20credentials/forgot_password_page.dart';
// import 'package:valuebuyin/login%20credentials/login_page.dart';
// import 'package:valuebuyin/login%20credentials/signup_page.dart';
// import 'package:valuebuyin/main.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   // Initialize Google Sign-In
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email'],
//   );

//   Future<void> _signUserIn() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email or password is empty')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Supabase.instance.client.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (response.user != null) {
//         // Login successful
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid email or password')),
//         );
//       }
//     } catch (e) {
//       if (e.toString().contains('email_not_confirmed')) {
//         // Allow login even if email is not confirmed
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Google Sign-In Function
//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Trigger Google Sign-In
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         // User canceled
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       // Get authentication details
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Sign in with Supabase
//       final response = await Supabase.instance.client.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//       );

//       if (response.user != null) {
//         // Google Sign-In successful
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Google Sign-In failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google Sign-In Error: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 50),
//                   // Lock icon
//                   const Icon(
//                     Icons.lock,
//                     size: 100,
//                   ),
//                   const SizedBox(height: 50),
//                   // Welcome text
//                   Text(
//                     'Welcome Back you\'ve been missed!',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   // Email text field
//                   MyTextfield(
//                     controller: _emailController,
//                     hintText: 'Email',
//                     obscureText: false, validator: (value) {  },
//                   ),
//                   const SizedBox(height: 25),
//                   // Password text field
//                   MyTextfield(
//                     controller: _passwordController,
//                     hintText: 'Password',
//                     obscureText: true, validator: (value) {  },
//                   ),
//                   const SizedBox(height: 25),
//                  GestureDetector(
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
//     );
//   },
//   child: Text(
//     'Forgot Password?',
//     style: TextStyle(
//       color: Colors.grey[600],
//       fontSize: 16,
//     ),
//   ),
// ),
//                   const SizedBox(height: 25),
//                   // Sign-in button
//                   MyButton(
//                     onTap: _isLoading ? null : _signUserIn,
//                     isLoading: _isLoading, text: '',
//                   ),
//                   const SizedBox(height: 50),
//                   // Or continue with
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Divider(
//                             thickness: 0.2,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             '  Or continue with  ',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             thickness: 0.5,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   // Google + Apple sign-in buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Google button
//                       GestureDetector(
//                         onTap: _isLoading ? null : _signInWithGoogle,
//                         child: SquareTile(imagePath: 'lib/images/google.png'),
//                       ),
//                       const SizedBox(width: 25),
//                       // Apple button (placeholder)
//                       SquareTile(imagePath: 'lib/images/apple.png'),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                   // Not a member? Register now
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const SignUpPage()),
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Not a member yet?',
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         const Text(
//                           'Register Now',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  final supabase = Supabase.instance.client;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await supabase.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        redirectTo: 'your-app-scheme://reset-password', // Update with your app's deep link
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Lock icon
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(height: 50),
                    // Instruction text
                    Text(
                      'Enter your email to reset your password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Email text field
                    MyTextfield(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (dynamic value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    // Error message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 25),
                    // Send reset link button
                    MyButton(
                      onTap: _isLoading ? null : _resetPassword,
                      isLoading: _isLoading,
                      text: 'Send Reset Link',
                    ),
                    const SizedBox(height: 50),
                    // Back to login
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Back to',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}