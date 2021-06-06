import 'package:html/dom.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

/// Does Works with `BaseMetadataParser`
class MetadataParser {
  /// This is the default strategy for building our [Metadata]
  ///
  /// It tries [OpenGraphParser], then [TwitterCardParser], then [JsonLdParser], and falls back to [HTMLMetaParser] tags for missing data.
  /// You may optionally provide a URL to the function, used to resolve relative images or to compensate for the lack of URI identifiers
  /// from the metadata parsers.
  static Metadata parse(Document? document, {String? url}) {
    final output = Metadata();

    final parsers = [
      openGraph(document),
      twitterCard(document),
      jsonLdSchema(document),
      htmlMeta(document),
    ];

    for (final p in parsers) {
      output.title ??= p.title;
      output.description ??= p.description;
      output.image ??= p.image;
      output.url ??= p.url;

      if (output.hasAllMetadata) {
        break;
      }
    }
    // If the parsers did not extract a URL from the metadata, use the given
    // url, if available. This is used to attempt to resolve relative images.
    final _url = output.url ?? url;
    final image = output.image;
    if (_url != null && image != null) {
      output.image = Uri.parse(_url).resolve(image).toString();
    }

    return output;
  }

  static Metadata openGraph(Document? document) {
    return OpenGraphParser(document).parse();
  }

  static Metadata htmlMeta(Document? document) {
    return HtmlMetaParser(document).parse();
  }

  static Metadata jsonLdSchema(Document? document) {
    return JsonLdParser(document).parse();
  }

  static Metadata twitterCard(Document? document) {
    return TwitterCardParser(document).parse();
  }
}
