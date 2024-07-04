import 'dart:io';
class MenuItem {
  String name;
  double price;
  String category;

  MenuItem(this.name, this.price, this.category);

  @override
  String toString() {
    return 'MenuItem{name: $name, price: $price, category: $category}';
  }
}

class Order {
  String orderId;
  int tableNumber;
  List<MenuItem> items = [];
  bool isCompleted = false;

  Order(this.orderId, this.tableNumber);

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  void completeOrder() {
    isCompleted = true;
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, tableNumber: $tableNumber, items: $items, isCompleted: $isCompleted}';
  }
}

class Restaurant {
  List<MenuItem> menu = [];
  List<Order> orders = [];
  Map<int, bool> tables = {};

  void addMenuItem(MenuItem item) {
    menu.add(item);
  }

  void removeMenuItem(MenuItem item) {
    menu.remove(item);
  }

  void placeOrder(Order order) {
    orders.add(order);
  }

  void completeOrder(String orderId) {
    for (var order in orders) {
      if (order.orderId == orderId) {
        order.completeOrder();
        print('Order $orderId completed.');
        return;
      }
    }
    print('Order $orderId not found.');
  }

  MenuItem? getMenuItem(String name) {
    return menu.firstWhere((item) => item.name == name, orElse: () => MenuItem('', 0.0, ''));
  }

  Order? getOrder(String orderId) {
    return orders.firstWhere((order) => order.orderId == orderId, orElse: () => Order('', 0));
  }

  @override
  String toString() {
    return 'Restaurant{menu: $menu, orders: $orders, tables: $tables}';
  }
}

void main() {
  Restaurant restaurant = Restaurant();

  while (true) {
    print('''
    ______________[ Restaurant ]______________
    1. Menu Item
    2. Order
    3. Search
    Q. Exit
    ''');
    stdout.write('Please enter your choice (1-3 or Q):');
    String? choice = stdin.readLineSync();

    if (choice == 'Q' || choice == 'q') {
      break;
    }

    switch (choice) {
      case '1':
        manageMenu(restaurant);
        break;
      case '2':
        manageOrder(restaurant);
        break;
      case '3':
        searchMenu(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void manageMenu(Restaurant restaurant) {
  while (true) {
    print('''
    ______________[ Menu ]______________
    1. Add
    2. Order
    3. Search
    0. Back
    ''');
    stdout.write('Please enter your choice (1-3 or 0):');

    String? choice = stdin.readLineSync();

    if (choice == '0') {
      break;
    }

    switch (choice) {
      case '1':
        addMenuItem(restaurant);
        break;
      case '2':
        manageOrder(restaurant);
        break;
      case '3':
        searchMenu(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void addMenuItem(Restaurant restaurant) {
  print('Add new menu item');
  stdout.write('Name: ');
  String? name = stdin.readLineSync();

  stdout.write('Price: ');
  String? priceInput = stdin.readLineSync();
  double price = double.tryParse(priceInput ?? '') ?? 0.0;

  stdout.write('Category (M=Main course, D=Dessert, W=Drink): ');
  String? category = stdin.readLineSync();

  if (name != null && category != null) {
    MenuItem newItem = MenuItem(name, price, category);
    restaurant.addMenuItem(newItem);
    print('Add name = [$name]\n  price = [$price]\n  Category = [$category]');
    stdout.write('Press Y to confirm: ');
    String? confirm = stdin.readLineSync();
    if (confirm != null && confirm.toUpperCase() == 'Y') {
      print('Menu item added successfully.');
    } else {
      print('Operation cancelled.');
    }
  } else {
    print('Invalid input. Please try again.');
  }
}

void manageOrder(Restaurant restaurant) {
  print('Manage Orders');
  while (true) {
    print('''
    1. Create new order
    2. Complete order
    0. Back
    ''');
    stdout.write('Please enter your choice (1-2 or 0):');
    String? choice = stdin.readLineSync();

    if (choice == '0') {
      break;
    }

    switch (choice) {
      case '1':
        createOrder(restaurant);
        break;
      case '2':
        completeOrder(restaurant);
        break;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

void createOrder(Restaurant restaurant) {
  stdout.write('Enter table number: ');
  String? tableNumberInput = stdin.readLineSync();
  int tableNumber = int.tryParse(tableNumberInput ?? '') ?? 0;

  stdout.write('Enter order ID: ');
  String? orderId = stdin.readLineSync();

  if (orderId != null) {
    Order newOrder = Order(orderId, tableNumber);
    while (true) {
      print('''
      1. Add item to order
      2. Remove item from order
      3. Finish creating order
      0. Back
      Please enter your choice (1-3 or 0):
      ''');
      String? choice = stdin.readLineSync();

      if (choice == '0' || choice == '3') {
        restaurant.placeOrder(newOrder);
        print('Order created successfully.');
        break;
      }

      switch (choice) {
        case '1':
          stdout.write('Enter item name to add: ');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            MenuItem? item = restaurant.getMenuItem(itemName);
            if (item != null && item.name.isNotEmpty) {
              newOrder.addItem(item);
              print('Item added to order.');
            } else {
              print('Item not found.');
            }
          }
          break;
        case '2':
          stdout.write('Enter item name to remove: ');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            MenuItem? item = restaurant.getMenuItem(itemName);
            if (item != null && item.name.isNotEmpty) {
              newOrder.removeItem(item);
              print('Item removed from order.');
            } else {
              print('Item not found.');
            }
          }
          break;
        default:
          print('Invalid choice, please try again.');
      }
    }
  } else {
    print('Invalid input. Please try again.');
  }
}

void completeOrder(Restaurant restaurant) {
  print('Complete Order');
  stdout.write('Enter order ID to complete: ');
  String? orderId = stdin.readLineSync();

  if (orderId != null) {
    restaurant.completeOrder(orderId);
  } else {
    print('Invalid input. Please try again.');
  }
}

void searchMenu(Restaurant restaurant) {
  print('Search Menu');
  stdout.write('Enter item name to search: ');
  String? itemName = stdin.readLineSync();

  if (itemName != null) {
    MenuItem? item = restaurant.getMenuItem(itemName);
    if (item != null && item.name.isNotEmpty) {
      print('Item found: $item');
    } else {
      print('Item not found.');
    }
  } else {
    print('Invalid input. Please try again.');
  }
}
