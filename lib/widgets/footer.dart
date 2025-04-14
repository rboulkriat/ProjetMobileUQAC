import 'package:flutter/material.dart';

import '../homePage/structurePage.dart';
import '../services/firebase_service.dart';

class CustomFooter extends StatefulWidget {
  @override
  _CustomFooterState createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(), // Désactive le défilement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.brown[50],
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Abonnez-vous à notre newsletter',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Et recevez les dernières mises à jour',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {}, // Empêche le focus automatique
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Entrez votre adresse e-mail',
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  padding: EdgeInsets.all(12.0),
                                  minimumSize: Size(50, 50),
                                ),
                                onPressed: () {
                                  String email = _emailController.text.trim();
                                  if (email.isNotEmpty) {

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Veuillez entrer une adresse e-mail valide.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(Icons.send, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 8.0),
                  Text(
                    "Vous pouvez vous désinscrire à tout moment. Vous trouverez pour cela nos informations de contact dans les conditions d'utilisation du site.",
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text('Snack Rush', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Titre de la rubrique principale
                        children: [
                          ListTile(
                            title: Text('> Notre histoire', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                          ListTile(
                            title: Text('> Partenaires', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                          ListTile(
                            title: Text('> Rejoignez-nous', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Nos conditions',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Titre de la rubrique principale
                        children: [
                          ListTile(
                            title: Text('> Conditions générales de vente', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {

                            },
                          ),
                          ListTile(
                            title: Text('> Mentions légales', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                          ListTile(
                            title: Text('> Politique de confidentialité', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Service client',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Titre de la rubrique principale
                        children: [
                          ListTile(
                            title: Text('> Contactez-nous', style: TextStyle(fontSize: 14)), // Titre de la sous-rubrique
                            onTap: () {
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: Colors.brown[100],
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Copyright © 2025 Snack Rush. Tous droits réservés.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
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


  @override
  void dispose() {
    _emailController.dispose(); // Disposez du contrôleur lorsque le widget est supprimé
    super.dispose();
  }
}