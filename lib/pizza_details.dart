import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secured_share_prefs/httpHelper.dart';
import 'package:secured_share_prefs/pizza.dart';

class PizzaDetails extends StatefulWidget {
  final Pizza pizza;
  final bool isNew;
  PizzaDetails(this.pizza , this.isNew);

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<PizzaDetails> {

  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtImageUrl = TextEditingController();
  // Result to show on screen
  String showResult= '';
  // If the information is updated then we need to initiallize values
  @override
  void initState(){
    if(!widget.isNew){
      txtId.text = widget.pizza.id.toString();
      txtName.text = widget.pizza.pizzaName.toString();
      txtDescription.text = widget.pizza.description.toString();
      txtPrice.text = widget.pizza.price.toString();
      txtImageUrl.text = widget.pizza.imageUrl.toString();
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pizza Details"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                showResult,
                style: TextStyle(background: Paint()..color = Colors.lightGreen,
                                color: Colors.black),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: txtId,
                decoration: InputDecoration(
                  labelText: 'Id ',
                ),
              ),
              TextFormField(
                controller: txtName,
                decoration: InputDecoration(
                  labelText: 'Name ',
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: txtDescription,
                decoration: InputDecoration(
                  labelText: 'Description ',
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: txtPrice,
                decoration: InputDecoration(
                  labelText: 'Price ',
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: txtImageUrl,
                decoration: InputDecoration(
                  labelText: 'Image Url ',
                ),
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                  onPressed: (){
                    savePizza();
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text("Save request") )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> savePizza()async{
    HttpHelper helper = HttpHelper();
    Pizza pizza = Pizza();
    pizza.id = int.tryParse(txtId.text.toString());
    pizza.pizzaName = txtName.text;
    pizza.description = txtDescription.text;
    pizza.price = double.tryParse(txtPrice.text.toString());
    pizza.imageUrl = txtImageUrl.text;
    String result = '';
    if (widget.isNew) {
      result = await helper.postPizza(pizza);
    } else {
      result = await helper.putPizza(pizza);
    }
    setState(() {
      showResult = result;
    });
    return result;
  }


}
