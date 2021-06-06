## 0.4.1
- Improve Documentation 

## 0.4.0

- NNBD (Null Safety) enabled
- Various API changes
- `extract()` and `responsetoDocument` are now encapsulated inside the `MetadataFetch` class. This is to avoid global clashes when imported.
- Removed the `requestURL` extension which served as a static variable attached to `http.Document`, which caused problems.
- `Metadata.parse(document, url: myURL)` now accepts the `url` keyword argument. This is used as a fallback url in `Metadata.url` and to resolve relative (non-absolute URL) images.

## 0.3.4

- Fix resolution of relative URL for images

## 0.3.3

- Relative image url now uses the absolute path

## 0.3.2

- Improved JsonLD Parser

## 0.3.1

- Added JSON serialization

## 0.3.0

- Added Twitter Card Parser
- Metadata structure now includes url

## 0.2.1

- Minor Improvements

## 0.2.0

- Improve API and generalized the Metadata Parser
- Added more documentation

## 0.1.1

- Various improvements throughout

## 0.1.0

- Initial version, created by Stagehand
