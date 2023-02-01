import 'package:bukateria/data/menus_list.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:flutter/material.dart';

class MenuSearchDelegate extends SearchDelegate {
  var items = menus;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<MenusModel> menusList = [];

    for (var i in menus) {
      if (i.title!.toLowerCase().contains(query.toLowerCase())) {
        menusList.add(i);
      }
    }

    return ListView.builder(
        itemCount: menusList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(menusList[index].title ?? ""),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<MenusModel> menusList = [];

    for (var i in menus) {
      if (i.title!.toLowerCase().contains(query.toLowerCase())) {
        menusList.add(i);
      }
    }

    return ListView.builder(
        itemCount: menusList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(menusList[index].title ?? ""),
          );
        });
  }
}



class RecipeSearchDelegate extends SearchDelegate {
  var items = recipes;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<MenusModel> RecipeList = [];

    for (var i in menus) {
      if (i.title!.toLowerCase().contains(query.toLowerCase())) {
        RecipeList.add(i);
      }
    }

    return ListView.builder(
        itemCount: RecipeList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(RecipeList[index]?.title ?? ""),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<MenusModel> recipeList = [];

    for (var i in menus) {
      if (i.title!.toLowerCase().contains(query.toLowerCase())) {
        recipeList.add(i);
      }
    }

    return ListView.builder(
        itemCount: recipeList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipeList[index].title??""),
          );
        });
  }
}
