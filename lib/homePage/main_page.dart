import 'package:flutter/material.dart';
import 'package:firebase_intro/homePage/structurePage.dart';
import '../services/firebase_service.dart';



class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: _MenuPrincipal(key: UniqueKey()),
    );
  }
}

class _MenuPrincipal extends StatelessWidget {
  final Key? key;
  final FirebaseAuthService _authService = FirebaseAuthService();

  _MenuPrincipal({this.key}) : super(key: key);

  Future<void> _precacheImages(BuildContext context, List<Map<String, dynamic>> products) async {
    for (var product in products) {
      await precacheImage(AssetImage(product['image']), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 350,
            width: double.infinity,
            child: PageView(
              controller: PageController(viewportFraction: 1),
              children: [
                Image.asset('assets/snacks/snack1.jpg', fit: BoxFit.cover),
                Image.asset('assets/snacks/sucre.webp', fit: BoxFit.cover),
                Image.asset('assets/snacks/sale.webp', fit: BoxFit.cover),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildCategoryCard(
                  title: 'Nos Sucré',
                  imagePath: 'assets/snacks/sucre.webp',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StructurePage(
                          selectedPage: 'NosSucre',
                        ),
                      ),
                    );
                  },
                ),
                _buildCategoryCard(
                  title: 'Nos Salé',
                  imagePath: 'assets/snacks/sale.webp',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StructurePage(
                          selectedPage: 'NosSale',
                        ),
                      ),
                    );
                  },
                ),
                _buildCategoryCard(
                  title: 'Nos Boissons',
                  imagePath: 'assets/snacks/boisson.jpg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StructurePage(
                          selectedPage: 'NosBoissons',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'NOS RECOMANDATIONS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontFamily: 'Lora',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 200.0,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _authService.getProductsByCategory(['Salé']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Une erreur est survenue : ${snapshot.error}'),
                    );
                  }

                  final products = snapshot.data;

                  if (products == null || products.isEmpty) {
                    return Center(child: Text('Aucun produit disponible.'));
                  }

                  return FutureBuilder<void>(
                    future: _precacheImages(context, products),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              print('Fetching product details...');
                              _authService.getInfo(product['name']).then((productInfo) {
                                print('Product details fetched: $productInfo');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StructurePage(
                                      selectedPage: 'NosSucre',
                                      productInfo: productInfo,
                                    ),
                                  ),
                                );
                              }).catchError((error) {
                                print('Erreur lors de la récupération des informations du produit: $error');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur lors de la récupération des informations du produit'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.brown[50],
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0),
                                        ),
                                        child: Image.asset(
                                          product['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'].length > 15 ? product['name'].substring(0, 15) + "..." : product['name'],
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'price: ${product['price']} €',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 1, 90, 15),
                                              fontSize: 12.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 50),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: BorderRadius.circular(15),
        ),
        height: 170.0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), // 🔥 Coins arrondis à gauche
              bottomLeft: Radius.circular(15),
              ),
              child: SizedBox(
              width: 170.0,
              height: 170.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Découvrir >',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
