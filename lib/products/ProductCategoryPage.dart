import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../widgets/PanierWidget.dart';
import '../../widgets/footer.dart';
import '../homePage/structurePage.dart';

class ProductCategoryPage extends StatefulWidget {
  final List<String> categories;

  ProductCategoryPage({required this.categories});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final Panier _panier = Panier();
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    /*print('RABBBBBBBAAAABBB');
    print(FirebaseAuthService().getUserIdFromEmail('Rababbboulkriat@outlook.fr'));*/

    return CustomScrollView(
      //backgroundColor: Colors.white,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Trier par:'),
                SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _authService.getProductsByCategory(widget.categories),
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


                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < (products.length / 2).ceil(); i++)
                          Row(
                            children: [
                              Expanded(
                                child: i * 2 < products.length
                                    ? buildProductItem(context, products[i * 2])
                                    : Container(),
                              ),
                              Expanded(
                                child: (i * 2 + 1) < products.length
                                    ? buildProductItem(context, products[i * 2 + 1])
                                    : Container(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            childCount: 1,
          ),
        ),
        CustomFooter(),
      ],
    );
  }

  Widget buildProductItem(BuildContext context, Map<String, dynamic> product) {
    final double prix = product['price'] is int ? (product['price'] as int).toDouble() : product['price'] as double;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print('Fetching product details...');
          _authService.getInfo(product['name']).then((productInfo) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              child: Image.asset(
                product['image'],
                height: 150, // Par exemple
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'price: ${prix.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 1, 90, 15),
                    ),
                  ),
                  SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(context, product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      'Ajouter au panier',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
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

  void addToCart(BuildContext context, Map<String, dynamic> product) {
    print('Produit ajouté au panier : ${product['name']}');
    _panier.ajouterElement(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit ajouté au panier : ${product['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}