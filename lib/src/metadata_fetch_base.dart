import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:html/dom.dart';
import 'package:metadata_fetch/src/parsers/parsers.dart';
import 'package:string_validator/string_validator.dart';

/// Fetches a [url], validates it, and returns [Map<String, String>] of metadata.
Future<Metadata> extract(String url) async {
  if (!isURL(url)) {
    return null;
  }

  /// Sane defaults; Always return the Domain name as the [title], and a [description] for a given [url]
  var default_output = Metadata();
  default_output.title = Uri.parse(url)?.host.toString().split('.')[0];
  default_output.description = url;

  // Make our network call
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

/// Takes an [http.Response] and returns a [dom.Document]
Document responseToDocument(http.Response response) {
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

/// This is the default strategy for building our [Metadata]
///
/// It tries [OpenGraphParser], and falls back to [HTMLMetaParser] tags for missing data.
Metadata _defaultStrategy(Document document) {
  var output = Metadata();
  // Default Strategy
  var openGraph = OpenGraphParser(document);
  var htmlMeta = HTMLMetaParser(document); // returns a Metadata

  var parsers = [openGraph, htmlMeta];

  for (final p in parsers) {
    output.title ??= p.title;
    output.description ??= p.description;
    output.image ??= p.image;

    // is there a cleaner way?
    final hasEmpty = ((output.title == null ||
            output.description == null ||
            output.image == null) ==
        true);

    if (!hasEmpty) {
      break;
    }
  }

  return output;
}

/// Returns instance of [Metadata] with data extracted from the [document]
///
/// Future: Can pass in a strategy i.e: to retrieve only OpenGraph, or OpenGraph and Json+LD only
Metadata _extractMetadata(Document document) {
  return _defaultStrategy(document);
}
