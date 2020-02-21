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
  // getMetadata fetches the metadata from a given url
  // It returns a Map<String,String> with title, description, and if found, an image
  // This doesn't throw errors, rather it returns null
  static Future<Map<String, String>> extract(String url) async {
    if (!isURL(url)) {
      return null;
    }

    final default_output = {
      'title': Uri.parse(url)?.host.toString().split('.')[0],
      'description': url,
    };

    var response = await http.get(url);
    var document = responseToDocument(response);

    if (document == null) {
      return default_output;
    }
    var data = _extractMetadata(document);
    if (data == null) {
      return default_output;
    }
    return data;
  }

  static Document responseToDocument(http.Response response) {
    if (response.statusCode != 200) {
      return null;
    }

    Document document;
    try {
      document = parser.parse(utf8.decode(response.bodyBytes));
    } catch (err) {
      return document;
    }

    return document;
  }

  // Loads the parser for each provider
  // openGraph
  // jsonLD
  // meta
  static Map<String, String> _extractMetadata(Document document) {
    var output = Map<String, String>();

    // Start with OpenGraph
    _getOpenGraphData(output, document);
    if (!output.containsKey(enumToString(MetadataProperty.title)) ||
        !output.containsKey(enumToString(MetadataProperty.description))) {
      _getMetaHtmlData(output, document);
    }
    return output;
  }

  static Map<String, String> _getOpenGraphData(
      Map<String, String> data, Document document) {
    var elements = document.head.querySelectorAll("[property*='og:']");

    elements.forEach((element) {
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

  static Map<String, String> _getMetaHtmlData(
      Map<String, String> data, Document document) {
    var metaElements = document.head.querySelectorAll('meta');

    var titleElement = document.head.querySelector('title');

    if (titleElement != null) {
      data[enumToString(MetadataProperty.title)] = titleElement.text;
    }

    metaElements.forEach((element) {
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
