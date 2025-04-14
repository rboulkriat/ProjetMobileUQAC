
import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../homePage/structurePage.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> productInfo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clé unique
  final FirebaseAuthService _authService = FirebaseAuthService();

  ProductDetailsPage(this.productInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    final String? cate = productInfo['category'] as String?;
    if (cate == null) {
      return Scaffold(
        body: Center(
          child: Text('La catégorie du produit est manquante.'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Affichage de l'image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        productInfo['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Affichage du nom et du prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            productInfo['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${(productInfo['price']).toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  // Affichage de la description
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          productInfo['description'],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Bouton "Ajouter au panier"
                  ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    ),
                    child: Text(
                      'Ajouter au panier',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Tableau encadré pour les détails du produit
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Détails du produit:',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(color: Colors.grey[300]!),
                          ),
                          columnWidths: {0: FlexColumnWidth(1)},
                          children: [
                            for (var entry in productInfo.entries)
                              if (entry.key != 'image' && entry.key != 'category')
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry.value.toString(),
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0),
                  // Titre pour la section "Découvrir également de la même gamme"
                  Text(
                    'Découvrir également de la même gamme :',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
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
                  future: _authService.getProductsByCategory([cate]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Une erreur est survenue : ${snapshot.error}',
                        ),
                      );
                    }

                    final products = snapshot.data;

                    if (products == null || products.isEmpty) {
                      return Center(child: Text('Aucun produit disponible.'));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            print('Fetching product details...');
                            _authService.getInfo(product['name']).then(
                                  (productInfo) {
                                print('Product details fetched: $productInfo');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StructurePage(
                                      selectedPage: 'ProduitDetail',
                                      productInfo: productInfo,
                                    ),
                                  ),
                                );
                              },
                            ).catchError((error) {
                              print(
                                'Erreur lors de la récupération des informations du produit: $error',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Erreur lors de la récupération des informations du produit',
                                  ),
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
                                        width: double.infinity, // Ajout de la largeur infinie pour l'image
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'].length > 15
                                              ? product['name'].substring(0, 15) +
                                              "..."
                                              : product['name'],
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
                                            color: Color.fromARGB(
                                                255, 1, 90, 15),
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
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
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
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // Image à gauche
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            // Texte à droite
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Some additional text',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: Icon(Icons.arrow_forward),
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
