import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomCountryController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> customCountries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomCountries();
  }

  // 🔥 Fetch custom countries in real time
  void fetchCustomCountries() {
    firestore.collection("custom_countries").snapshots().listen((snapshot) {
      customCountries.value =
          snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    });
  }

  // 🔥 Add a new country
  Future<void> addCountry(String name, String capital, String region, int population) async {
    await firestore.collection("custom_countries").add({
      "name": name,
      "capital": capital,
      "region": region,
      "population": population,
    });
  }

  // 🔥 Update country details
  Future<void> updateCountry(String id, String name, String capital, String region, int population) async {
    await firestore.collection("custom_countries").doc(id).update({
      "name": name,
      "capital": capital,
      "region": region,
      "population": population,
    });
  }

  // 🔥 Delete country from Firestore
  Future<void> deleteCountry(String id) async {
    await firestore.collection("custom_countries").doc(id).delete();
  }


}

