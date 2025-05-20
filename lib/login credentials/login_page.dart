// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
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

//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Supabase.instance.client.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (response.user != null) {
//         // Login successful, navigate to HomePage
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
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $e')));
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('')),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(
//               'lib/assets/valuebuy.in.png', // Replace with your logo path
//               height: 250,
//             ),
//             const SizedBox(height: 75),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     borderSide: const BorderSide(
//                       color: Colors.orangeAccent,
//                       width: 2.0,
//                     ),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.email,
//                     color: Colors.orangeAccent,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     borderSide: const BorderSide(
//                       color: Colors.orangeAccent,
//                       width: 2.0,
//                     ),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.lock,
//                     color: Colors.orangeAccent,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _login,
//               child:
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text(
//                         'Login',
//                         style: TextStyle(color: Colors.white),
//                       ),
//               style: ElevatedButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 5,
//                   horizontal: 50,
//                 ),
//                 backgroundColor: Colors.orangeAccent[700],
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to the Sign-Up Page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignUpPage()),
//                 );
//               },
//               child: const Text(
//                 'Sign Up',
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 5,
//                   horizontal: 50,
//                 ),
//                 backgroundColor: Colors.redAccent[700],
//               ),
//             ),
//             const SizedBox(height: 150),
//           ],
//         ),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:valuebuyin/components/my_button.dart';
// import 'package:valuebuyin/components/my_textfield.dart';
// import 'package:valuebuyin/components/square_tile.dart';
// import 'package:valuebuyin/login%20credentials/forgot_password_page.dart';
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
//       final googleAuth = await googleUser.authentication;

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

// class ForgotPasswordPage extends StatelessWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Forgot Password')),
//       body: const Center(
//         child: Text('Forgot Password Page'),
//       ),
//     );
//   }
// }
















import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:valuebuyin/components/my_button.dart';
import 'package:valuebuyin/components/my_textfield.dart' as components;
import 'package:valuebuyin/components/square_tile.dart';
import 'package:valuebuyin/login%20credentials/forgot_password_page.dart';
import 'package:valuebuyin/login%20credentials/signup_page.dart';
import 'package:valuebuyin/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Initialize Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _signUserIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password is empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      if (e.toString().contains('email_not_confirmed')) {
        // Allow login even if email is not confirmed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Sign-In Function
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get authentication details
      final googleAuth = await googleUser.authentication;

      // Sign in with Supabase
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      if (response.user != null) {
        // Google Sign-In successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo image
                  Image.network(
                    'lib/images/valuebuy.in.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  // Welcome text
                  Text(
                    'Welcome Back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Email text field
                  components.MyTextfield(
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
                  // Password text field
                  components.MyTextfield(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (dynamic value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  // Forgot Password
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Sign-in button
                  MyButton(
                    onTap: _isLoading ? null : _signUserIn,
                    isLoading: _isLoading,
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 50),
                  // Or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.2,
                            color: Colors.grey[700],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Google + Apple sign-in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google button
                      GestureDetector(
                        onTap: _isLoading ? null : _signInWithGoogle,
                        child: const SquareTile(imagePath: 'lib/images/google.png'),
                      ),
                      const SizedBox(width: 25),
                      // Apple button (placeholder)
                      const SquareTile(imagePath: 'lib/images/apple.png'),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Not a member? Register now
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member yet?',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Register Now',
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
    );
  }
}