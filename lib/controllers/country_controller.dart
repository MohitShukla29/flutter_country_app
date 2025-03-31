import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CountryController extends GetxController {
  var countries = <dynamic>[].obs;
  var filteredCountries = <dynamic>[].obs;
  var customCountries = <dynamic>[].obs;
  var isLoading = true.obs;
  var sortAscending = true.obs;
  RxInt itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse("${dotenv.env['api_key_endpoint']}"),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        countries.assignAll(data);
        filteredCountries.assignAll(
          data.take(10).toList(),
        ); // Initially show 10 countries
      } else {
        Get.snackbar("Error", "Failed to load countries");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    } finally {
      isLoading.value = false;
    }
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries.assignAll(
        countries.take(10),
      ); // Reset to first 10 if empty search
    } else {
      filteredCountries.assignAll(
        countries
            .where(
              (country) => country["name"]["common"]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void sortCountries() {
    sortAscending.value = !sortAscending.value;

    // Sort the full list BEFORE applying pagination
    countries.sort(
      (a, b) =>
          sortAscending.value
              ? a["population"].compareTo(b["population"])
              : b["population"].compareTo(a["population"]),
    );

    // Apply pagination after sorting
    filteredCountries.assignAll(countries.take(itemsPerPage.value));
  }

  void addCustomCountry(
    String name,
    String capital,
    String region,
    int population,
  ) {
    var newCountry = {
      "id": DateTime.now().toString(), // Unique ID for deletion
      "name": {"common": name},
      "capital": [capital],
      "region": region,
      "population": population,
      "flags": {"png": "https://via.placeholder.com/50"},
    };

    customCountries.add(newCountry);
  }

  void deleteCustomCountry(String id) {
    customCountries.removeWhere((country) => country["id"] == id);
  }

  void loadMoreCountries() {
    int newLimit = itemsPerPage.value + 10;
    if (newLimit <= countries.length) {
      itemsPerPage.value = newLimit;
    } else {
      itemsPerPage.value =
          countries.length; // Prevent exceeding total countries
    }

    // Always take sorted countries
    filteredCountries.assignAll(countries.take(itemsPerPage.value));
  }
}
