import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map? mapResponse;
  List facts = [];

  Future fetchData() async {
    http.Response response;
    var link = 'https://www.thegrowingdeveloper.org';
    var uri = Uri.parse('$link/apiview?id=2&type=application/json');
    response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        facts = mapResponse?['facts'];
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Fetch data from internet'),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: mapResponse == null ? Container() : SingleChildScrollView(
        child: Column(
          children: [
            Text(
              mapResponse!['category'].toString(),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.network(facts[index]['image_url']),
                    Text(
                      facts[index]['title'].toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      facts[index]['description'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
              itemCount: facts.length,
            )
          ],
        ),
      )
    );
  }
}
