import 'package:html/dom.dart';
import 'package:metadata_fetch/src/metadata_fetch_base.dart';

abstract class MetadataParser {
  String getTitle();
  String getDescription();
  String getImage();
}

class HTMLMeta extends MetadataParser {
  Document document;

  HTMLMeta(this.document);

  @override
  String getTitle() {
    var titleElement = document.head.querySelector('title');
    return titleElement.text;
  }

  @override
  String getDescription() {
    var metaElements = document.head.querySelectorAll('meta');
    var candidate = metaElements
        .firstWhere((element) => element.attributes['name'] == 'description')
        .attributes['content'];
    return candidate;
  }

  @override
  String getImage() {
    // Get the first image in the body
    var imageElement = document.body.querySelector('img');
    var candidate = imageElement.attributes['src'];
    return candidate;
  }
}

class OpenGraphParser extends MetadataParser {
  Document document;

  OpenGraphParser(this.document);

  @override
  String getTitle() => document.head
      .querySelector("[property*='og:title']")
      .attributes['content'];

  @override
  String getDescription() {
    var metaElements = document.head.querySelectorAll('meta');
    var candidate = metaElements
        .firstWhere((element) => element.attributes['name'] == 'description')
        .attributes['content'];
    return candidate;
  }

  @override
  String getImage() {
    // Get the first image in the body
    var imageElement = document.body.querySelector('img');
    var candidate = imageElement.attributes['src'];
    return candidate;
  }
}
