import 'dart:convert';

import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.document] and parses [Metadata] from `json-ld` data in `<script>`
class JsonLdParser with BaseMetadataParser {
  /// The [document] to be parse
  Document document;
  dynamic _jsonData;

  JsonLdParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document document) {
    final data = document?.head
        ?.querySelector("script[type='application/ld+json']")
        ?.innerHtml;
    if (data == null) {
      return null;
    }
    var d = jsonDecode(data);
    return d;
  }

  /// Get the [Metadata.title] from the [<title>] tag
  @override
  String get title {
    final data = _jsonData;
    if (data is List) {
      return data?.first['name'];
    } else if (data is Map) {
      return data?.get('name') ?? data?.get('headline');
    }
    return null;
  }

  /// Get the [Metadata.description] from the <meta name="description" content=""> tag
  @override
  String get description {
    final data = _jsonData;
    if (data is List) {
      return data?.first['description'] ?? data?.first['headline'];
    } else if (data is Map) {
      return data?.get('description') ?? data?.get('headline');
    }
    return null;
  }

  /// Get the [Metadata.image] from the first <img> tag in the body;s
  @override
  String get image {
    final data = _jsonData;
    if (data is List && data.isNotEmpty) {
      return _imageResultToString(data?.first['logo'] ?? data?.first['image']);
    } else if (data is Map) {
      return _imageResultToString(
          data?.getDynamic('logo') ?? data?.getDynamic('image'));
    }

    return null;
  }

  String _imageResultToString(dynamic result) {
    if (result is List && result.isNotEmpty) {
      result = result.first;
    }

    if (result is String) {
      return result;
    }

    return null;
  }

  /// Get the document request URL from Document's [HttpRequestData] extension.
  @override
  String get url => document?.requestUrl;

  @override
  String toString() => this.parse().toString();
}
