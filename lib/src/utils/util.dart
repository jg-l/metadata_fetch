import 'package:html/dom.dart';

extension GetMethod on Map {
  String get(dynamic Key) {
    return (this[Key]);
  }

  dynamic getDynamic(dynamic Key) {
    return (this[Key]);
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
