import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search here'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Action for notifications
            },
          ),
        ],
      ),
      body: const HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for chat
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? homeData;

  @override
  void initState() {
    super.initState();
    fetchHomePageData();
  }

  // Fetch the data from API
  Future<void> fetchHomePageData() async {
    final response = await http.get(
      Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'),
    );

    if (response.statusCode == 200) {
      setState(() {
        homeData = jsonDecode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load home data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return homeData == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display banners
                buildBanners(homeData!['banner_one']),

                // KYC Pending section
                buildKycPendingSection(),

                // Categories
                buildCategoryGrid(homeData!['category']),

                // Products Section
                buildProductsList(homeData!['products']),
              ],
            ),
          );
  }

  // Build banners (Carousel or List)
  Widget buildBanners(List<dynamic> banners) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: banners[index]['banner'],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          );
        },
      ),
    );
  }

  // KYC Pending Section
  Widget buildKycPendingSection() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'KYC Pending',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'You need to provide the required documents for your account activation.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Action for KYC
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Click Here'),
          ),
        ],
      ),
    );
  }

  // Build Categories Grid
  Widget buildCategoryGrid(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CachedNetworkImage(
                imageUrl: categories[index]['icon'],
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 8),
              Text(categories[index]['label'], style: const TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );
  }

  // Build Products List (Horizontal Scroll)
  Widget buildProductsList(List<dynamic> products) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exclusive for You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  icon: products[index]['icon'],
                  label: products[index]['label'],
                  subLabel: products[index]['SubLabel'] ?? '',
                  offer: products[index]['offer'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final String icon;
  final String label;
  final String subLabel;
  final String offer;

  const ProductCard({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.offer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: icon,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text('$offer OFF', style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
