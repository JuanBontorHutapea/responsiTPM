import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailMakananPage extends StatelessWidget {
  final String mealId;

  const DetailMakananPage({required this.mealId});

  Future<Map<String, dynamic>> fetchMealDetails() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'][0];
    } else {
      throw Exception('Failed to fetch meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Makanan'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMealDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to fetch meal details'),
            );
          } else {
            final meal = snapshot.data!;
            final mealName = meal['strMeal'];
            final mealCategory = meal['strCategory'];
            final mealArea = meal['strArea'];
            final mealInstructions = meal['strInstructions'];
            final mealImage = meal['strMealThumb'];
            String  youtubeUrl = meal['strYoutube'];

            return Card(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  SizedBox(
                    height: 200.0,
                    width: 100.0,
                    child: Image.network(
                      mealImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      mealName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Area: $mealArea',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'Category: $mealCategory',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    mealInstructions,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 90, 185, 94),
                      ),
                      onPressed: () {
                        launch(youtubeUrl);
                      },
                      child: Text(
                        'Youtube Link',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  
                ],
              ),
            );
          }
        },
      ),
    );
  }
}