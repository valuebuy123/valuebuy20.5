import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/login credentials/login_page.dart';
import 'package:valuebuyin/main.dart';
import 'package:valuebuyin/nav_bar.dart';
import 'package:valuebuyin/pages/adress/saved_address_page.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart'; // Corrected import path
import 'package:valuebuyin/controllers/address_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildInfoCard(String title, String value, double screenWidth) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.black38)),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(
    BuildContext context,
    CartController cartController,
  ) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      cartController.clearCart();
      await Supabase.instance.client.auth.signOut();
      Get.back();
      Get.snackbar(
        'Logout',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      Get.snackbar(
        'Error',
        'Failed to log out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final CartController cartController = Get.find<CartController>();
    final AddressController addressController = Get.find<AddressController>();

    final RxBool notificationsEnabled = true.obs;
    final RxString selectedLanguage = 'English'.obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.08,
                      backgroundColor: Colors.orangeAccent[700],
                      child: Text(
                        'U',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: Supabase.instance.client
                              .from('users')
                              .select('user_name')
                              .eq(
                                'id',
                                Supabase.instance.client.auth.currentUser!.id,
                              )
                              .maybeSingle(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.050,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.red,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              final userName =
                                  snapshot.data?['user_name'] ?? 'No Name';
                              return Text(
                                userName,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return Text(
                                'No Name',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        FutureBuilder(
                          future: Supabase.instance.client.auth.getUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.red,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              final user = snapshot.data?.user;
                              return Text(
                                user?.email ?? 'No Email',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey,
                                ),
                              );
                            } else {
                              return Text(
                                'No Email',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              FutureBuilder(
                future: Supabase.instance.client
                    .from('users')
                    .select('user_name')
                    .eq(
                      'id',
                      Supabase.instance.client.auth.currentUser?.id ?? '',
                    )
                    .maybeSingle(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildInfoCard(
                      'user Name',
                      'Loading...',
                      screenWidth,
                    );
                  } else if (snapshot.hasError) {
                    return _buildInfoCard(
                      'user Name',
                      'Error: ${snapshot.error}',
                      screenWidth,
                    );
                  } else if (snapshot.hasData) {
                    final userName = snapshot.data?['user_name'] ?? 'No Name';
                    return _buildInfoCard('user Name', userName, screenWidth);
                  } else {
                    return _buildInfoCard('user Name', 'No Name', screenWidth);
                  }
                },
              ),
              FutureBuilder(
                future: Supabase.instance.client
                    .from('users')
                    .select('phone_number')
                    .eq(
                      'id',
                      Supabase.instance.client.auth.currentUser?.id ?? '',
                    )
                    .maybeSingle(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildInfoCard(
                      'Phone Number',
                      'Loading...',
                      screenWidth,
                    );
                  } else if (snapshot.hasError) {
                    return _buildInfoCard(
                      'Phone Number',
                      'Error: ${snapshot.error}',
                      screenWidth,
                    );
                  } else if (snapshot.hasData) {
                    final mobileNumber = snapshot.data?['phone_number'] ?? 0;
                    return _buildInfoCard(
                      'Phone Number',
                      mobileNumber.toString(),
                      screenWidth,
                    );
                  } else {
                    return _buildInfoCard(
                      'Phone Number',
                      'No Phone Number',
                      screenWidth,
                    );
                  }
                },
              ),
              _buildInfoCard(
                'Email',
                Supabase.instance.client.auth.currentUser?.email ?? 'No Email',
                screenWidth,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.orangeAccent[700],
                ),
                title: Text(
                  'Saved Addresses',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () {
                  Get.to(() => const SavedAddressPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.orangeAccent[700]),
                title: Text(
                  'Order History',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () {
                  Get.to(() => const OrdersPage(products: [])); // Adjusted constructor if necessary
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.orangeAccent[700]),
                title: Text(
                  'Change Password',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController oldPasswordController =
                          TextEditingController();
                      final TextEditingController newPasswordController =
                          TextEditingController();
                      return AlertDialog(
                        title: const Text('Change Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: oldPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Old Password',
                              ),
                              obscureText: true,
                            ),
                            TextField(
                              controller: newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                'Success',
                                'Password changed successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Change'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.orangeAccent[700]),
                title: Text(
                  'App Settings',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () {
                  Get.to(() => const AppSettingsPage());
                },
              ),
              Obx(
                () => ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.orangeAccent[700],
                  ),
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  trailing: Switch(
                    value: notificationsEnabled.value,
                    onChanged: (value) {
                      notificationsEnabled.value = value;
                      Get.snackbar(
                        'Notifications',
                        'Toggled to $value',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    activeColor: Colors.orangeAccent[700],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.orangeAccent[700]),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () async {
                  await _logout(context, cartController);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationMenu(currentIndex: 3, onTap: (index) {  },),
    );
  }
}

class OrdersPage {
  const OrdersPage({required List products});
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orangeAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'App Settings',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.info, color: Colors.orangeAccent[700]),
              title: Text(
                'About',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              onTap: () {
                Get.snackbar(
                  'About',
                  'This application is developed for demo purposes.',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.orangeAccent[700]),
              title: Text(
                'Privacy',
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              onTap: () {
                Get.snackbar(
                  'Privacy',
                  'Privacy policy is not available yet.',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}