
class Panier {
  List<Map<String, dynamic>> _elements = [];
  Function()? _updateCallback;

  static final Panier _instance = Panier._internal();

  factory Panier() {
    return _instance;
  }

  Panier._internal();

  void ajouterElement(Map<String, dynamic> product) {
    bool produitExistant = false;

    for (var element in _elements) {
      if (element['name'] == product['name']) {
        element['quantite'] += 1;
        produitExistant = true;
        break;
      }
    }

    if (!produitExistant) {
      // Vérifiez si le prix est un double, sinon convertissez-le
      if (product['price'] is int) {
        product['price'] = (product['price'] as int).toDouble();
      }
      product['quantite'] = 1;
      _elements.add(product);
    }

    _notifyUpdate();
  }

  double supprimerElement(int index) {
    _elements.removeAt(index);

    // Recalculer le prix total après suppression de l'élément
    double nouveauTotal = _elements.fold(0, (sum, item) {
      return sum + (item['price'] as double) * (item['quantite'] as int);
    });

    // Notifier les écouteurs de mise à jour
    _notifyUpdate();

    return nouveauTotal;
  }


  List<Map<String, dynamic>> getPanier() {
    return this._elements;
  }

  void updatePanier(List<Map<String, dynamic>> newPanier) {
    _elements = newPanier;
    _notifyUpdate();
  }

  void registerUpdateCallback(Function() callback) {
    _updateCallback = callback;
  }

  void _notifyUpdate() {
    if (_updateCallback != null) {
      _updateCallback!();
    }
  }
  int getNombreElements() {
    int nb = 0;
    for (var element in _elements) {
      nb += element['quantite'] as int; // Ajoute simplement la quantité de chaque produit au total
    }
    return nb;
  }


}