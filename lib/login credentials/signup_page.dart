// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:valuebuyin/login%20credentials/login_page.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();

//   Future<void> _signUp() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final name = _nameController.text.trim();
//     final phone = _phoneController.text.trim();

//     try {
//       // Sign up the user with email and password
//       final response = await Supabase.instance.client.auth.signUp(
//         email: email,
//         password: password,
//       );

//       if (response.user != null) {
//         // Insert additional user data into the "users" table
//         final insertResponse = await Supabase.instance.client
//             .from('users')
//             .insert({
//               'email': email,
//               'password': password,
//               'user_name': name,
//               'phone_number': phone,
//             }); // Ensure you call execute() to get a proper response

//         if (insertResponse.error == Object) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(const SnackBar(content: Text('Sign-Up Successful!')));
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${insertResponse.error!.message}')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Sign-Up Failed')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
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
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: TextField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
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
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.1),
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
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: TextField(
//                 controller: _passwordController,
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
//                 ),
//                 obscureText: true,
//               ),
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: () {
//                 _signUp().then((_) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 });
//               },
//               child: const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0, // Adjust the font size as needed
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               style: ElevatedButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 75,
//                 ),
//                 backgroundColor: Colors.orangeAccent[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/login%20credentials/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      // Sign up the user with email and password
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Insert additional user data into the "users" table
        final insertResponse = await Supabase.instance.client
            .from('users')
            .insert({
              'email': email,
              'password': password,
              'user_name': name,
              'phone_number': phone,
            }); // Ensure you call execute() to get a proper response

        if (insertResponse.error == Object) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-Up Successful!')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${insertResponse.error!.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign-Up Failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _signUp().then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                });
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0, // Adjust the font size as needed
                ),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 75,
                ),
                backgroundColor: Colors.orangeAccent[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

