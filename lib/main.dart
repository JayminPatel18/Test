import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<getUsers> users = [];
  int counter = 0;

  Future<getUsers> fetchUsers() async {
    var baseUrl = "http://api.anviya.in/getUsers.php?page=$counter";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
      //print(data[0].videos);
      return getUsers.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch Materials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                      future: fetchUsers(),
                      builder: (context, AsyncSnapshot<getUsers> snapshot) {
                        if (snapshot.hasError) {
                          print('Something Went Wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    SizedBox(height: 10.0),
                            itemCount: snapshot.data?.data?.users?.length ?? 0,
                            itemBuilder: (context, index) {
                              var name =
                                  snapshot.data?.data?.users?[index].name ??
                                      "NO Name";
                              var phone =
                                  snapshot.data?.data?.users?[index].phone ??
                                      "NO Name";
                              var email =
                                  snapshot.data?.data?.users?[index].email ??
                                      "NO Name";
                              var image = snapshot
                                      .data?.data?.users?[index].profileImage ??
                                  "NO Name";
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(14)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.scaleDown,
                                            image: NetworkImage(image),
                                          )),
                                    )
                                  ],
                                ),
                              );
                            });
                      }))
            ],
          ),
        ));
  }
}

class getUsers {
  Data? data;

  getUsers({this.data});

  getUsers.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalPage;
  String? currentPage;
  List<Users>? users;

  Data({this.totalPage, this.currentPage, this.users});

  Data.fromJson(Map<String, dynamic> json) {
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPage'] = this.totalPage;
    data['currentPage'] = this.currentPage;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;

  Users({this.id, this.name, this.email, this.phone, this.profileImage});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
