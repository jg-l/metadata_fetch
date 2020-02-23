import 'dart:convert';

import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.document] and parses [Metadata] from `json-ld` data in `<script>`
class JsonLdParser extends BaseMetadataParser {
  /// The [document] to be parse
  Document document;
  dynamic _jsonData;

  JsonLdParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document document) {
    var data = document?.head
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
    var data = _jsonData;
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
    var data = _jsonData;
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
    var data = _jsonData;
    if (data is List) {
      return data?.first['logo'] ?? data?.first['image']?.first;
    } else if (data is Map) {
      return data?.get('logo') ?? data['image'][0];
    }
    return null;
  }
}
