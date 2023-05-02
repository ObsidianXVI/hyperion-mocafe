part of mocafe_mkproj;

class Drink {
  final String name;
  final int ingredientToksNeeded;
  final double monetaryValue;

  Drink(this.name, this.ingredientToksNeeded, this.monetaryValue);
}

class FetchMenuAction extends Action<FetchMenuArgSet> {
  FetchMenuAction()
      : super(
          body: (ArgSet argSet) {
            argSet as FetchMenuArgSet;
            List<Drink> trimMenu(List<Drink> originalMenu) {
              if (argSet.menuSize <= originalMenu.length) {
                return originalMenu.sublist(0, argSet.menuSize);
              } else {
                throw Exception("Trim size exceeds menu length");
              }
            }

            final List<Drink> fullMenu = [
              Drink('Latte', 10, 0.8),
              Drink('Cappuccino', 5, 0.3),
              Drink('Espresso', 3, 0.4),
              Drink('Americano', 7, 0.7),
              Drink('Black', 2, 0.3),
            ];
            argSet.menuCell.update(trimMenu(fullMenu));
          },
        );
}

class FetchMenuArgSet extends ArgSet {
  final int menuSize;
  final ListCell<Drink> menuCell;

  /// This constructor shows my initial idea of letting the model
  /// pick the menu size itself. The named constructors demonstrate the fact
  /// that I discretised the parameter space.
  /* FetchMenuArgSet({
    required this.menuSize,
  }); */

  const FetchMenuArgSet.size0(this.menuCell)
      : menuSize = 0,
        super(dimensions: 1, values: const [0]);
  const FetchMenuArgSet.size1(this.menuCell)
      : menuSize = 1,
        super(dimensions: 1, values: const [1]);
  const FetchMenuArgSet.size2(this.menuCell)
      : menuSize = 2,
        super(dimensions: 1, values: const [2]);
  const FetchMenuArgSet.size3(this.menuCell)
      : menuSize = 3,
        super(dimensions: 1, values: const [3]);
  const FetchMenuArgSet.size4(this.menuCell)
      : menuSize = 4,
        super(dimensions: 1, values: const [4]);

  @override
  String toInstanceLabel() {
    return "FetchMenuArgSet()<$menuSize>";
  }

  @override
  String toString() => toInstanceLabel();
}
