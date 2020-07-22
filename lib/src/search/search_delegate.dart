import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  String selection='';
  final peliculasProvider = new PeliculasProvider();

  final peliculas=[
    'spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ad astra',

  ];

  final peliculasRecientes=[
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions apppbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izq appbar search
    return IconButton(
      icon: AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // resultados que mostrará
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color:Colors.blueAccent,
        child: Text(selection),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias mientras searching
    if(query.isEmpty){
      return Container();
    }  
    return FutureBuilder(
      future:peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context,AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas=snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit:BoxFit.contain
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId='';
                  Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  
  }
}
  // final listaSugerida=query.isEmpty?peliculasRecientes:peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title:Text(listaSugerida[index]),
  //         onTap: (){
  //           selection=listaSugerida[index];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }