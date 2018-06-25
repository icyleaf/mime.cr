# Mime.cr

![Language](https://img.shields.io/badge/language-crystal-776791.svg)
[![Tag](https://img.shields.io/github/tag/icyleaf/mime.cr.svg)](https://github.com/icyleaf/mime.cr/blob/master/CHANGELOG.md)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/mime.cr/master.svg?style=flat)](https://circleci.com/gh/icyleaf/mime.cr)
[![License](https://img.shields.io/github/license/icyleaf/mime.cr.svg)](https://github.com/icyleaf/mime.cr/blob/master/LICENSE)


Mime types for Crystal. Data from [node-mime](https://github.com/broofa/node-mime) and inspired from [mime-types](https://github.com/jshttp/mime-types).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  mime:
    github: icyleaf/mime.cr
```

## API

```crystal
require "mime"
```

### Mime.loopup(path)

Lookup the content-type associated with a file.

```crystal
Mime.lookup "db.json"           # => application/json
Mime.lookup ".md"               # => text/markdown
Mime.lookup "xml"               # => application/xml
Mime.lookup "path/to/file.js"   # => application/javascript
Mime.lookup ".gitignore"        # => nil
```

### Mime.content_type(type)

Create a full content-type header given file(extension) or content-type

```crystal
Mime.content_type "db.json"           # => application/json, charset=utf-8
Mime.content_type "xml", "GBK2312"    # => application/xml, charset=gbk2312
Mime.content_type ".gitignore"        # => nil
```

### Mime.extension(type)

Get the extension from a content-type.

```crystal
Mime.extension "text/html"    # => html
Mime.extension "i-dont-know"  # => nil
```

### Mime.charset(type)

Get the charset from a content-type.

```crystal
Mime.charset "application/json; charset=gbk2312"  # => gbk2312
Mime.charset "text/html"                          # => utf-8
```

## Development

### Update data to db file

```crystal
$ shards build
$ ./bin/mime_builder
I, [2018-06-25 14:29:33 +08:00 #63109]  INFO -- : Download standard mime types ...
I, [2018-06-25 14:29:36 +08:00 #63109]  INFO -- : New mime types found: 2.
I, [2018-06-25 14:29:38 +08:00 #65239]  INFO -- : Write to file ...
```

## Contributing

1. Fork it (<https://github.com/icyleaf/mime/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) icyleaf - creator, maintainer
