import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyGetHttpData(),
  ));
}

class MyGetHttpData extends StatefulWidget{
  @override
  MyGetHttpDataState createState() => MyGetHttpDataState();
}

class MyGetHttpDataState extends State<MyGetHttpData>{
  final String url = "https://rickandmortyapi.com/api/character/";
  List data;

  //Funcion para obtener la información JSON
  Future<String> getJSONData() async {
    var response = await http.get(
       // Encode the url
       Uri.encodeFull(url),
       // Aceptar solo JSON por respuesta
       headers: {"Accept":"application/json"}
    );

    //Log de la respuesta
    print(response.body);

    // Modificar el estado de la app
    setState((){
      // Obtener la informacion JSON
      var dataConvertedToJSON = json.decode(response.body);
      
      // Extraer la parte requerida y asignarla a una variable data
      data = dataConvertedToJSON['results'];
     });

     return "Exitoso";
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CodeCrafters"),
      ),

      //Crear una listview y cargar la informacion disponible
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
	  itemBuilder: (BuildContext context, int index){
	  return Container(
	      child: Center(
	      	 child: Column(
		 //Mostrar tarjetas en eje horizontal
		 crossAxisAlignment: CrossAxisAlignment.stretch,
		 children: <Widget>[
		   Card(
		     child: ListTile(
		       leading: Image.network(data[index]['image']),
		       title: Text(data[index]['name']),
		       subtitle: Text(data[index]['status']),

		       onTap: (){
		         Navigator.push(
			   context, MaterialPageRoute(
			     builder: (context) => DetailsInfo(data[index]['image'],data[index]['name']),
			  ),
			 );
		       }
		     ),
		   )
		 ],
		 )
	      ),
	  );
	  
 	}
      ),

    );
  }

  @override
  void initState(){
     super.initState();
     //Call the getJSON Data()
     this.getJSONData();
  }
}

class DetailsInfo extends StatelessWidget {
  String image;
  String name;
  DetailsInfo(this.image,this.name);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(this.name),
      ),
      body: Center(
        child: Image.network(this.image)
      ),
    );
  }
}