import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_country_app/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/country_controller.dart';
import '../controllers/userController.dart';

class CountryListScreen extends StatelessWidget {
  final CountryController countryController = Get.put(CountryController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Countries"),
        actions: [
          Obx(() {
            var userController = Get.find<UserController>();
            return userController.userModel.value?.profilePictureUrl != null &&
                    userController
                        .userModel
                        .value!
                        .profilePictureUrl!
                        .isNotEmpty
                ? GestureDetector(
                  onTap: () => Get.toNamed('/profile'),
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(
                      base64Decode(
                        userController.userModel.value!.profilePictureUrl!,
                      ),
                    ),
                  ),
                )
                : IconButton(
                  icon: Icon(Icons.account_circle, size: 30),
                  onPressed: () => Get.toNamed('/profile'),
                );
          }),
        ],
      ),

      body: Obx(() {
        if (countryController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildSearchAndSort(),
            Expanded(
              child: ListView(
                children: [
                  _buildPaginatedCountryList(),
                  Divider(),
                  _buildCustomCountryList(),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCountryDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchAndSort() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Search Country",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: Get.find<CountryController>().filterCountries,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: Get.find<CountryController>().sortCountries,
            child: Obx(
              () => Text(
                Get.find<CountryController>().sortAscending.value
                    ? "Sort by Population ↓"
                    : "Sort by Population ↑",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginatedCountryList() {
    return Column(
      children: [
        ...Get.find<CountryController>().filteredCountries
            .map((country) => _buildCountryTile(country))
            .toList(),
        Obx(
          () =>
              Get.find<CountryController>().itemsPerPage.value <
                      Get.find<CountryController>().countries.length
                  ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed:
                          Get.find<CountryController>().loadMoreCountries,
                      child: Text("Load More"),
                    ),
                  )
                  : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildCountryTile(dynamic country) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading:
            country["flags"] != null
                ? Image.network(country["flags"]["png"], width: 50, height: 30)
                : Icon(Icons.flag),
        title: Text(country["name"]["common"]),
        subtitle: Text(
          "Capital: ${country["capital"]?[0] ?? "N/A"}\nRegion: ${country["region"]}\nPopulation: ${country["population"]}",
        ),
      ),
    );
  }

  Widget _buildCustomCountryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Custom Added Countries",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('custom_countries')
                  .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Column(
              children: [
                ...snapshot.data!.docs.map((doc) {
                  return ListTile(
                    title: Text(doc["name"]),
                    subtitle: Text(
                      "Capital: ${doc["capital"]}, Population: ${doc["population"]}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(doc),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCountry(doc.id),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(height: 80),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showAddCountryDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController capitalController = TextEditingController();
    TextEditingController regionController = TextEditingController();
    TextEditingController populationController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text("Add Custom Country"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: capitalController,
              decoration: InputDecoration(labelText: "Capital"),
            ),
            TextField(
              controller: regionController,
              decoration: InputDecoration(labelText: "Region"),
            ),
            TextField(
              controller: populationController,
              decoration: InputDecoration(labelText: "Population"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('custom_countries')
                  .add({
                    "name": nameController.text,
                    "capital": capitalController.text,
                    "region": regionController.text,
                    "population": int.parse(populationController.text),
                  });
              Get.back();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(QueryDocumentSnapshot doc) {
    TextEditingController nameController = TextEditingController(
      text: doc["name"],
    );
    TextEditingController capitalController = TextEditingController(
      text: doc["capital"],
    );
    TextEditingController populationController = TextEditingController(
      text: doc["population"].toString(),
    );

    Get.dialog(
      AlertDialog(
        title: Text("Edit Country"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: capitalController,
              decoration: InputDecoration(labelText: "Capital"),
            ),
            TextField(
              controller: populationController,
              decoration: InputDecoration(labelText: "Population"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('custom_countries')
                  .doc(doc.id)
                  .update({
                    "name": nameController.text,
                    "capital": capitalController.text,
                    "population": int.parse(populationController.text),
                  });
              Get.back();
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _deleteCountry(String id) async {
    await FirebaseFirestore.instance
        .collection('custom_countries')
        .doc(id)
        .delete();
  }
}
