import 'package:flutter/material.dart';
import './add_food_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Grocery App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.indigo[600],
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          headline2: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      home: MyTodos(title: 'Feed Me'),
    );
  }
}

class MyTodos extends StatefulWidget {
  const MyTodos({@required this.title});

  final String title;

  @override
  _MyTodosState createState() => _MyTodosState();
}

class _MyTodosState extends State<MyTodos> {
  int _selectedIndex = 0;

  List<String> _toBuy = [
    "Apples",
    "Pears",
    "Bananas",
    "Cereal",
  ];

  List<String> _inStock = [
    "Spinach",
  ];

  List<String> _outOfStock = [
    "Bread",
  ];

  List<String> _favourites = [
    
  ];

  void toggleList(bool newVal, bool inStock, bool onList, int index, bool isFavourite) {
    if (inStock && !onList) {
      String item = _inStock[index];
      _inStock.removeAt(index);
      if (isFavourite) {
        setState(() => _toBuy.add(item));
      } else {
        setState(() => _outOfStock.add(item));
      }
    } else if (!inStock && onList) {
      String item = _toBuy[index];
      _toBuy.removeAt(index);
      setState(() => _inStock.add(item));
    } else if (!inStock && !onList) {
      String item = _outOfStock[index];
      _outOfStock.removeAt(index);
      setState(() => _toBuy.add(item));
    }
  }

  void toggleFavourite(int favouriteIndex, bool isFavourite, String name) {
    if (isFavourite && favouriteIndex >= 0 && favouriteIndex < _favourites.length) {
      // String item = _favourites[favouriteIndex];
      setState(() => _favourites.removeAt(favouriteIndex));
    } else {
      setState(() => _favourites.add(name));
    }
  }

  // void toggleStock(BuildContext context, bool newVal, int index) {
  //   if (!newVal) {
  //     String item = _inStock[index];
  //     _inStock.removeAt(index);
  //     setState(() => _outOfStock.add(item));
  //   } else if (newVal) {
  //     String item = _outOfStock[index];
  //     _outOfStock.removeAt(index);
  //     setState(() => _toBuy.add(item));
  //   }
  // }


  void _addTodo(BuildContext context) async {
    String newTodo = await showDialog(
      context: context,
      builder: (context) => new AddTodoDialog(),
    );

    if (newTodo != null) setState(() => _toBuy.add(newTodo));
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _groceryList() {
    List<Widget> children = [];
    for (int i = 0; i < _toBuy.length; i++) {
      String item = _toBuy[i];
      bool favourite = false;
      int favouriteIndex = -1; 
      for (int j = 0; j < _favourites.length; j++) {
        if (item == _favourites[j]){
          favourite = true;
          favouriteIndex = j;
        }
      }
      children.add(FoodItem(
        name: item,
        inStock: false,
        index: i,
        toggleList: toggleList,
        onList: true,
        isFavourite: favourite,
        favouriteIndex: favouriteIndex,
        toggleFavourite: toggleFavourite,
      ));
    }
    return children;
  }

  List<Widget> _inStockList() {
    List<Widget> children = [];

    for (int i = 0; i < _inStock.length; i++) {
      String item = _inStock[i];
      bool favourite = false;
      int favouriteIndex = -1; 
      for (int j = 0; j < _favourites.length; j++) {
        if (item == _favourites[j]){
          favourite = true;
          favouriteIndex = j;
        }
      }
      children.add(FoodItem(
        name: item,
        inStock: true,
        onList: false,
        index: i,
        toggleList: toggleList,
        isFavourite: favourite,
        favouriteIndex: favouriteIndex,
        toggleFavourite: toggleFavourite,
      ));
    }
    return children;
  }

  List<Widget> _outOfStockList() {
    List<Widget> children = [];

    for (int i = 0; i < _outOfStock.length; i++) {
      String item = _outOfStock[i];
      bool favourite = false;
      int favouriteIndex = -1; 
      for (int j = 0; j < _favourites.length; j++) {
        if (item == _favourites[j]){
          favourite = true;
          favouriteIndex = j;
        }
      }
      children.add(FoodItem(
        name: item,
        inStock: false,
        onList: false,
        index: i,
        toggleList: toggleList,
        isFavourite: favourite,
        favouriteIndex: favouriteIndex,
        toggleFavourite: toggleFavourite,
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addTodo(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _selectedIndex==0 ? Text("In my Fridge", style: Theme.of(context).textTheme.headline1) 
              : Text("To Buy", style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 10),
            _selectedIndex==0 ? Column(children: _inStockList())
              : Column(children: _groceryList()),
            SizedBox(height: 10),
            _selectedIndex==0 ? Text("Out of Stock", style: Theme.of(context).textTheme.headline1)
              : Text("In My Cart", style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 10),
            _selectedIndex==0 ? Column(children: _outOfStockList())
              : Column(children: _inStockList()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining_rounded),
            title: Text('My Fridge'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            title: Text('My List')
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTappedItem,
      ),
    );
  }
}


class FoodItem extends StatelessWidget {
  FoodItem({
    @required this.name,
    @required this.inStock,
    @required this.onList,
    @required this.isFavourite,
    @required this.index,
    //@required this.toggleStock,
    @required this.toggleList,
    @required this.toggleFavourite,
    @required this.favouriteIndex,
  });

  final String name;
  final bool inStock;
  final bool onList;
  final bool isFavourite;
  final int index;
  //final Function toggleStock;
  final Function toggleList;
  final Function toggleFavourite;
  final int favouriteIndex;

  // void toggleFavourite() {
  //   if (this.isFavourite) {
  //     this.isFavourite = false;
  //   } else {
  //     this.isFavourite = true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: inStock ? Colors.grey[300] : Colors.white,
          border: Border.all(
            color: inStock ? Colors.grey[300] : Colors.grey[400],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          )),
      child: Row(
        children: [
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: inStock,
            onChanged: (bool newVal) => toggleList(newVal, inStock, onList, index, isFavourite),
          ),
          Text(
            name,
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: (isFavourite ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: Colors.yellowAccent[700],
            onPressed: () => toggleFavourite(favouriteIndex, isFavourite, name),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}