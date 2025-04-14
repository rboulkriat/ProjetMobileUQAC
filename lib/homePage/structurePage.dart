import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../panier/panier.dart';
import '../products/ProductCategoryPage.dart';
import '../products/product_info.dart';
import '../widgets/PanierWidget.dart';
import 'main_page.dart';


class StructurePage extends StatefulWidget {
  final String selectedPage;
  final dynamic productInfo;

  StructurePage({required this.selectedPage, this.productInfo});

  @override
  _StructurePageState createState() =>
      _StructurePageState(selectedPage, productInfo);
}

class _StructurePageState extends State<StructurePage>
    with SingleTickerProviderStateMixin {
  String _selectedPage;
  dynamic _productInfo;
  bool _isDelicesExpanded = false;
  bool _isCoffretsExpanded = false;
  bool _isEvenementsExpanded = false;
  bool _isQuiSommesNousExpanded = false;

  final FirebaseAuthService _authService = FirebaseAuthService();

  _StructurePageState(this._selectedPage, this._productInfo);

  @override
  void initState() {
    super.initState();
  }


    Widget _buildDrawerItem({required String title, required Function() onTap}) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      );
    }

    Widget _buildDrawerSousItem({required String title, required Function() onTap}) {
      return ListTile(
        title: Text(
          '    $title',
          style: TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      );
    }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(10.0),
      child: Text(
        '© 2024 Your Company. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black54,
        ),
      ),
    );
  }

    Widget _buildExpandableDrawerItem({
      required String title,
      required bool isExpanded,
      required Function() onTap,
      required List<Widget> children,
    }) {
      return ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        children: children,
      );
    }

    void _navigateTo(String page) {
      setState(() {
        _selectedPage = page;
      });
      Navigator.pop(context);
    }


    Widget _buildDrawer() {
      return Container(
          color: Colors.purple,
          alignment: Alignment.center,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  title: 'Accueil',
                  onTap: () {
                    _navigateTo('MenuPrincipal');
                  },
                ),
                _buildExpandableDrawerItem(
                  title: 'Nos Sucrés',
                  isExpanded: _isDelicesExpanded,
                  onTap: () {
                    setState(() {
                      _isDelicesExpanded = !_isDelicesExpanded;
                    });
                  },
                  children: [
                    _buildDrawerSousItem(
                      title: 'Chocolats',
                      onTap: () {
                        _navigateTo('NosDelicesALaPiece');
                      },
                    ),
                    _buildDrawerSousItem(
                      title: 'Bonbons',
                      onTap: () {
                        _navigateTo('NosDelicesLesSables');
                      },
                    ),
                  ],
                ),
                _buildDrawerItem(
                  title: 'Nos Salés',
                  onTap: () {
                    _navigateTo('NosSale');
                  },

                ),
                _buildDrawerItem(
                  title: 'Boissons',
                  onTap: () {
                    _navigateTo('NosBoissons');
                  },
                ),
                  ],
                ),
            )
      );
    }


  Widget _buildBody() {
    switch (_selectedPage) {
      case 'MenuPrincipal':
        return MainPage();
      case 'NosSucre':
        return ProductCategoryPage(categories: ['Salé']);
      case 'NosSale':
        return  ProductCategoryPage(categories: ['Salé']);
      case 'NosBoissons':
        return ProductCategoryPage(categories: ['Boisson']);
      case 'ProduitDetail':
        return ProductDetailsPage(_productInfo);
      case 'Panier':
        return PanierWidget();
      default:
        return MainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snack Rush"), // Remplace par le titre souhaité
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.9,
                  child: PanierWidget(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      drawer: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7, // Ajustez la largeur du Drawer selon vos besoins
        child: _buildDrawer(),
      ),
    );
  }
  }
