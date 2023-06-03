import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsitpm/view/meal.dart';

class Category {
  final String strCategory;
  final String strCategoryThumb;

  Category(this.strCategory, this.strCategoryThumb);
}

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<Category> categories = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoryList = data['categories'] as List<dynamic>;

        setState(() {
          categories = categoryList
              .map((category) => Category(
                  category['strCategory'], category['strCategoryThumb']))
              .toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void navigateToDetailPage(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListMakananPage(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              navigateToDetailPage(categories[index].strCategory);
            },
            child: Card(
              elevation: 10,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: 30,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          width: 300,
                          height: 120,
                          child: Image.network(
                            categories[index].strCategoryThumb,
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categories[index].strCategory,
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
