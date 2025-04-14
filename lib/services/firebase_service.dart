import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/toast.dart';


class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Map<String, dynamic>>> getProductsByCategory(List<String> categories) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('snacks').where('category', whereIn: categories).get();
      return querySnapshot.docs.map((doc) => {
        'image': doc['image'],
        'name': doc['name'],
        'price': doc['price'],
      }).toList();
    } catch (e) {
      print('Error getting products by category: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInfo(String productName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('snacks').where('name', isEqualTo: productName).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        throw Exception('Produit introuvable');
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations du produit: $e');
      rethrow;
    }
  }

  void handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'invalid-credential') {
      showToast(message: 'Les informations d\'identification fournies sont incorrectes.');
    } else if (e.code == 'user-mismatch') {
      showToast(message: 'Les informations d\'identification ne correspondent pas à l\'utilisateur actuel.');
    } else if (e.code == 'user-not-found') {
      showToast(message: 'Utilisateur non trouvé.');
    } else if (e.code == 'requires-recent-login') {
      showToast(message: 'Cette opération nécessite une connexion récente. Veuillez vous reconnecter.');
    } else {
      showToast(message: 'Erreur lors de la ré-authentification: ${e.message}');
    }
    print('Erreur lors de la ré-authentification : ${e.code} - ${e.message}');
  }
}
