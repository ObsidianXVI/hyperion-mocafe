part of mocafe_mkproj;

class Drink {
  final String name;
  final int ingredientToksNeeded;

  Drink(this.name, this.ingredientToksNeeded);
}

class FetchMenuAction extends Action<List<Drink>> {
  FetchMenuAction()
      : super(
          body: (ArgSet<Action<List<Drink>>> argSet) {
            return [
              Drink('Latte', 10),
              Drink('Cappuccino', 5),
              Drink('Espresso', 3),
              Drink('Americano', 7),
              Drink('Black', 2),
            ].sublist(1);
          },
        );
}

class FetchMenuArgSet extends ArgSet<FetchMenuAction> {
  final int menuSize;

  /// This constructor shows my initial idea of letting the model
  /// pick the menu size itself. The named constructors demonstrate the fact
  /// that I discretised the parameter space.
  /* FetchMenuArgSet({
    required this.menuSize,
  }); */

  FetchMenuArgSet.size0() : menuSize = 0;
  FetchMenuArgSet.size1() : menuSize = 1;
  FetchMenuArgSet.size2() : menuSize = 2;
  FetchMenuArgSet.size3() : menuSize = 3;
  FetchMenuArgSet.size4() : menuSize = 4;

  List<Drink> trimMenu(List<Drink> originalMenu) {
    if (menuSize < originalMenu.length) {
      return originalMenu.sublist(0, menuSize);
    } else {
      throw Exception("Trim size exceeds menu length");
    }
  }
}
