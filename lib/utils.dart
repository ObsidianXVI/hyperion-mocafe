part of mocafe;

final Random _rnd = Random();
const _chars = '1234567890';

class Utils {
  static String genId() => String.fromCharCodes(Iterable.generate(
      6, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  static int genInt([int min = 5, int max = 10]) =>
      min + _rnd.nextInt(max - min);
}
