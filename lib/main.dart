// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secured_share_prefs/httpHelper.dart';
import 'package:secured_share_prefs/pizza.dart';
import 'package:secured_share_prefs/pizza_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController passwardControlller = TextEditingController();
  final storage = FlutterSecureStorage();
  String key= 'myPass';

  Future writeToSecureStorage()async{
    await storage.write(key: key, value: passwardControlller.value.text);
  }
  // read form storage
  Future<String> readFromSecureStorage()async{
    String secret= '';
     secret = (await storage.read(key: key))!;
    return secret;
  }

  // Methods for getting pizza list from httpHelper class
  Future<List<Pizza>> callPizzas() async{
    HttpHelper helper = HttpHelper();
    List<Pizza>? pizzas = await helper.getPizzaList();
    return pizzas!;
  }
  // Init Method
  @override
  void initState(){

    callPizzas();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Path Provider"),
          backgroundColor: Colors.lightGreen,

        ),
          body: FutureBuilder(
            future: callPizzas(),
            builder: (BuildContext context , AsyncSnapshot<List<Pizza>> pizzas){
              return ListView.builder(
                itemCount: pizzas.data?.length == null ? 0 : pizzas.data?.length ,
                  itemBuilder: (context , int count){
                    return Dismissible(
                      key: Key(count.toString()),
                      onDismissed: (item){
                          HttpHelper helper = HttpHelper();
                          pizzas.data?.removeWhere((element) => element.id == pizzas.data?[count].id);
                          helper.deletePizza(pizzas.data?[count].id);
                      },

                      child: ListTile(
                        title: Text("${pizzas.data?[count].pizzaName}"),
                        subtitle: Text("${pizzas.data?[count].description} for \$ ${pizzas.data?[count].price}"),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PizzaDetails(Pizza(), false)));
                        },
                      ),
                    );

                  }

              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context , MaterialPageRoute(builder: (context) => PizzaDetails(Pizza(), false) ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }


}

// removed content

//Column(
//             children: [
//               TextFormField(
//                 controller: passwardControlller,
//
//               ),
//               ElevatedButton(
//                   onPressed: (){
//                     setState(() {
//                       writeToSecureStorage();
//
//                     });
//                     passwardControlller.clear();
//                   },
//                   child: Text("Save value")),
//
//               ElevatedButton(
//                   onPressed: (){
//                       readFromSecureStorage().then((value){
//                         setState(() {
//                           key = value;
//                         });
//                       });
//                   },
//                   child: Text("Read value")),
//
//               Text(key),
//               SizedBox(height: 10,),
//
//
//             ],
//           ),