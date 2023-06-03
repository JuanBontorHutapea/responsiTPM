import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsitpm/view/meal_detail.dart';

class ListMakananPage extends StatefulWidget {
  final String category;

  const ListMakananPage({required this.category});

  @override
  _ListMakananPageState createState() => _ListMakananPageState();
}

class _ListMakananPageState extends State<ListMakananPage> {
  List<dynamic> meals = [];
  int _currentIndex = 0;

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meals = data['meals'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('List Makanan - ${widget.category}'),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: meals.length,
        itemBuilder: (BuildContext context, int index) {
          final meal = meals[index];
          final mealName = meal['strMeal'];
          final mealImage = meal['strMealThumb'];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMakananPage(mealId: meal['idMeal']),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      mealImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      mealName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}