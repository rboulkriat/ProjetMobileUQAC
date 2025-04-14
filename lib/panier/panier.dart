import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../widgets/PanierWidget.dart';


class PanierWidget extends StatefulWidget {
  @override
  _PanierWidgetState createState() => _PanierWidgetState();
}

class _PanierWidgetState extends State<PanierWidget> {
  List<Map<String, dynamic>> panier = [];
  int nombreElements = 0;
  double total = 0;
  double prixTotal = 0;
  double ancienPrixTotal = 0; // Nouvelle variable pour stocker l'ancien prix

  @override
  void initState() {
    super.initState();
    panier = Panier().getPanier();
    nombreElements = panier.length;
    Panier().registerUpdateCallback(() {
      setState(() {
        panier = Panier().getPanier();
        nombreElements = panier.length;
        // Recalculer le prix total lorsque le panier est mis à jour
        recalculerPrixTotal();
      });
    });
    for (var product in panier) {
      if (product['price'] is int) {
        product['price'] = (product['price'] as int).toDouble();
      }
    }
    recalculerPrixTotal();
  }

  void updatePrixPanier(double nouveauTotal) {
    setState(() {
      ancienPrixTotal = prixTotal; // Sauvegarder l'ancien prix avant la mise à jour
      prixTotal = nouveauTotal; // Mettre à jour le prix total
    });
    print('TON IDD RABABBABAABABABBA');
    //print(FirebaseAuthService().getUserId());


  }

  void recalculerPrixTotal() {
    total = 0;
    for (var product in panier) {
      int quantite = product['quantite'] as int;
      double prixUnitaire = product['price'] as double;
      total += prixUnitaire * quantite;
    }
    setState(() {
      prixTotal = total; // Mettre à jour le prix total
      ancienPrixTotal = prixTotal; // Mettre à jour l'ancien prix total
    });
  }


  @override
  Widget build(BuildContext context) {
    int quantiteTotal = 0;
    for (var product in panier) {
      int quantite = product['quantite'] as int;
      quantiteTotal += quantite;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Votre Panier'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '$quantiteTotal articles',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
      body: panier.isEmpty
          ? Center(
        child: Text(
          'Panier vide',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: panier.length + 1, // +1 pour la ligne Total
        itemBuilder: (context, index) {
          if (index < panier.length) {
            final product = panier[index];
            int quantite = product['quantite'] as int;
            double prixUnitaire = product['price'] as double;
            double prixTotalProduit = prixUnitaire * quantite;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    // Votre logique pour afficher les détails du produit
                  },
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product['name'],
                  style: TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prix unitaire: ${prixUnitaire.toStringAsFixed(2)} €',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Quantité: ',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    DropdownButton<int>(
                      value: quantite,
                      onChanged: (value) {
                        setState(() {
                          product['quantite'] = value;
                          // Recalculer le total après modification de la quantité
                          recalculerPrixTotal();
                        });
                      },
                      items: List.generate(
                        10,
                            (index) => DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                    Text(
                      'Prix total: ${prixTotalProduit.toStringAsFixed(2)} €',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      double nouveauTotal =
                      Panier().supprimerElement(index);
                      prixTotal = nouveauTotal;
                      ancienPrixTotal =
                          prixTotal; // Mise à jour de l'ancien prix total après suppression
                    });
                  },
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end, // Alignement des enfants à gauche
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.blueGrey, // Couleur de fond du bouton
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Bord arrondi
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                          ),
                          onPressed: () {  },
                          child: Text(
                            'Ajouter un code promo',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Couleur du texte
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${quantiteTotal} articles',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Ancien total: ${ancienPrixTotal.toStringAsFixed(2)} €',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey),
                          ),
                          Text(
                            'Nouveau total: ${prixTotal.toStringAsFixed(2)} €',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Livraison',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        'Gratuit',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  Divider(
                    color:
                    Color.fromARGB(255, 103, 102, 102),
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total TTC',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight:
                            FontWeight.bold),
                      ),
                      Text(
                        '${prixTotal.toStringAsFixed(2)} €', // Utiliser prixTotal pour l'affichage
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight:
                            FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style:  ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromARGB(255, 144, 143, 143),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Commander',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}