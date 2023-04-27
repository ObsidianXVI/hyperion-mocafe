part of mocafe_mkproj;

class MocafeDataStore extends DataStore {
  final ListCell<Drink> menuCell = ListCell([
    Drink('Latte', 10, 0.8),
    Drink('Cappuccino', 5, 0.3),
    Drink('Espresso', 3, 0.4),
    Drink('Americano', 7, 0.7),
    Drink('Black', 2, 0.3),
  ]);
}
