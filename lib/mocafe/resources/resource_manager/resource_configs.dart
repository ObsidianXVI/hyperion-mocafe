part of mocafe_mkproj;

class MocafeResourceConfigs extends ResourceConfigs {
  final int ingredientTokens;

  MocafeResourceConfigs({
    super.memoryTokens,
    super.networkEgressTokens,
    super.networkIngressTokens,
    super.processingTokens,
    required this.ingredientTokens,
  });
}
