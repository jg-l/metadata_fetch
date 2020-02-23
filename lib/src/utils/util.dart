extension GetMethod on Map {
  String get(dynamic Key) {
    return (this[Key]);
  }
}

String getDomain(String url) {
  return Uri.parse(url)?.host.toString().split('.')[0];
}
