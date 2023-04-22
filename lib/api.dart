part of mocafe;

class API {
  static final HttpClient httpClient = HttpClient();
  static Future<List<String>> getDrinksAvailable() async {
    final HttpClientResponse response = (await (await httpClient
            .getUrl(Uri.https("api.sampleapis.com", "/coffee/hot")))
        .close());
    return List<Map>.from(
            json.decode(await response.transform(utf8.decoder).join()))
        .map((Map m) => m['title'] as String)
        .toList();
  }
}
