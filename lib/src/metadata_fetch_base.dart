import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:metadata_fetch/src/metadata_property.dart';
import 'package:html/dom.dart';
import 'package:string_validator/string_validator.dart';

final _requiredMetadata = [
  MetadataProperty.title,
  MetadataProperty.description
];
final _optionalMetadata = [MetadataProperty.image];

class MetadataFetch {
  static Future<Map<String, String>> getMetadata(String url) async {
    if (!isURL(url)) {
      return null;
    }
    var response = await http.get(url);
    var output = _parseResponse(response);
    if (output == null) {
      return {'title': url, 'description': null};
    }
    return output;
  }

  static Map<String, String> _parseResponse(http.Response response) {
    if (response.statusCode != 200) {
      return null;
    }

    var output = Map<String, String>();

    Document document;
    try {
      document = parser.parse(utf8.decode(response.bodyBytes));
    } catch (err) {
      return null;
    }

    return extractMetadata(output, document);
  }

  static Map<String, String> extractMetadata(
      Map<String, String> m, Document document) {
    m = _getOpenGraphData(document);
    if (!m.containsKey('title') || !m.containsKey('description')) {
      m = _getMetaHtmlData(document);
    }
    return m;
  }

  static Map<String, String> _getOpenGraphData(Document document) {
    var metadata = document.head.querySelectorAll("[property*='og:']");

    var data = Map<String, String>();

    metadata.forEach((element) {
      var tagProperty = element.attributes['property'].split('og:')[1];
      var tagContent = element.attributes['content'];

      if (_requiredMetadata.contains(stringToEnum(tagProperty))) {
        data[tagProperty] = tagContent;
      }
      if (_optionalMetadata.contains(stringToEnum(tagProperty))) {
        data[tagProperty] = tagContent;
      }
    });

    return data;
  }

  static Map<String, String> _getMetaHtmlData(Document document) {
    var metadata = document.head.querySelectorAll('meta');

    // get title
    var titleElement = document.head.querySelector('title');

    var data = Map<String, String>();

    if (titleElement != null) {
      data[enumToString(MetadataProperty.title)] = titleElement.text;
    }

    metadata.forEach((element) {
      var tagProperty = element.attributes['name'];
      var tagContent = element.attributes['content'];

      if (_requiredMetadata.contains(stringToEnum(tagProperty))) {
        data[tagProperty] = tagContent;
      }
      if (_optionalMetadata.contains(stringToEnum(tagProperty))) {
        data[tagProperty] = tagContent;
      }
    });

    return data;
  }
}
