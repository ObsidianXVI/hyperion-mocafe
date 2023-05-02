part of mocafe_mkproj;

class MocafeResourceManager extends ResourceManager {
  int ingredientTokens;
  final MocafeResourceConfigs mocafeResourceConfigs;

  MocafeResourceManager(this.mocafeResourceConfigs)
      : ingredientTokens = mocafeResourceConfigs.ingredientTokens,
        super(mocafeResourceConfigs);

  @override
  void reset() {
    super.reset();
    ingredientTokens = mocafeResourceConfigs.ingredientTokens;
  }
}
