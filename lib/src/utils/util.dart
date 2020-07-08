import 'package:html/dom.dart';

extension GetMethod on Map {
  String get(dynamic key) {
    var value = this[key];
    if (value is List) return value.first;
    return value.toString();
  }

  dynamic getDynamic(dynamic key) {
    return this[key];
  }
}

/// Adds getter/setter for the original [Response.request.url]
extension HttpRequestData on Document {
  static String _requestUrl;

  String get requestUrl {
    return _requestUrl;
  }

  set requestUrl(String newValue) {
    _requestUrl = newValue;
  }

}

String getDomain(String url) {
  return Uri.parse(url)?.host.toString().split('.')[0];
}
