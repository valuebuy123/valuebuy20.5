import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:valuebuyin/pages/adress/edit_address_page.dart';
import 'package:valuebuyin/pages/adress/saved_address_page.dart';
import 'package:valuebuyin/pages/cart/cart_controller.dart';
import 'package:valuebuyin/controllers/address_controller.dart';
import 'package:valuebuyin/controllers/order_controller.dart' as controllers;
import 'package:valuebuyin/pages/cart/cart_page.dart';
import 'package:valuebuyin/pages/product_grid_screen.dart';
import 'package:valuebuyin/login%20credentials/login_page.dart';
import 'package:valuebuyin/nav_bar.dart';
import 'package:valuebuyin/widgets/category_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://xfgrxmbysmngnwkzipkq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmZ3J4bWJ5c21uZ253a3ppcGtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNjc0MzgsImV4cCI6MjA1NDk0MzQzOH0.y72dz0mzcvEwyatpMZ4TVwDp2wZaydYRg4lDVu166fk',
  );

  // Initialize GetX controllers
  Get.put(CartController());
  Get.put(AddressController());
  Get.put(controllers.OrderController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ValueBuyIn',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:
          Supabase.instance.client.auth.currentSession == null ? '/login' : '/',
      getPages: [
        GetPage(
          name: '/',
          page: () {
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              return const HomeScreen();
            } else {
              return const LoginPage();
            }
          },
        ),
        GetPage(name: '/store', page: () => const ProductGridScreen()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(
          name: '/profile',
          page: () {
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              return ProfilePage(uid: user.id);
            } else {
              return const LoginPage();
            }
          },
        ),
        // GetPage(name: '/orders', page: () => const OrdersPage(products: [])),
        GetPage(name: '/saved_addresses', page: () => const SavedAddressPage()),
        GetPage(
          name: '/edit_address',
          page: () {
            final int index = Get.arguments as int? ?? 0;
            final AddressController addressController =
                Get.find<AddressController>();
            final address = addressController.addresses[index];
            return EditAddressPage(address: address, index: index);
          },
        ),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['Flour', 'Oil', 'Salt & Sugar'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.black, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Color.fromARGB(255, 150, 97, 0),
                    ),
                    onPressed: () async {
                      final cartController = Get.find<CartController>();
                      cartController.fetchCartItems();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                  Obx(() {
                    int itemCount = cartController.getTotalItemCount();
                    return itemCount > 0
                        ? Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.orangeAccent[700],
                  labelColor: Colors.orangeAccent[700],
                  unselectedLabelColor: Colors.grey,
                  tabs:
                      categories
                          .map((category) => Tab(text: category))
                          .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            categories
                .map((category) => CategoryList(category: category))
                .toList(),
      ),
      bottomNavigationBar: NavigationMenu(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation logic here
          print('Navigated to index: $index');
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  Widget _buildInfoCard(String title, String value, double screenWidth) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black38),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                          future:
                              Supabase.instance.client
                                  .from('users')
                                  .select('user_name')
                                  .eq('id', uid)
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
                future:
                    Supabase.instance.client
                        .from('users')
                        .select('user_name')
                        .eq('id', uid)
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
                future:
                    Supabase.instance.client
                        .from('users')
                        .select('phone_number')
                        .eq('id', uid)
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
                    final mobileNumber =
                        snapshot.data?['phone_number']?.toString() ??
                        'No Phone Number';
                    return _buildInfoCard(
                      'Phone Number',
                      mobileNumber,
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
                  Get.toNamed('/saved_addresses');
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.orangeAccent[700]),
                title: Text(
                  'Order History',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                onTap: () {
                  Get.toNamed('/orders');
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
