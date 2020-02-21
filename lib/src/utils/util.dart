extension GetMethod on Map {
  String get(dynamic Key) {
    return (this[Key]);
  }
}

String getDomain(String url) {
  var domain = Uri.parse(url)?.host.toString().split('.')[0];
  return domain[0].toUpperCase() + domain.substring(1); // Oof
}
