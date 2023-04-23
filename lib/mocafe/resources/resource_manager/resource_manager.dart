part of mocafe_mkproj;

class MocafeResourceManager extends ResourceManager {
  int ingredientTokens;

  MocafeResourceManager(MocafeResourceConfigs resourceConfigs)
      : ingredientTokens = resourceConfigs.ingredientTokens,
        super(resourceConfigs);
}
