require "./mime/db"
require "./mime/version"

module Mime
  extend self

  DEFAULT_CHARSET = "utf-8"

  # Create a full Content-Type header given a MIME type or extension.
  #
  # https://www.w3.org/TR/WD-html40-970708/charset.html
  #
  # ### Example
  #
  # ```
  # Salt::Mime.content_type("html") # => "application/html, charset=utf-8"
  # Salt::Mime.content_type(".html", "gbk-2312") # => "application/html, charset=gbk-2312"
  # Salt::Mime.content_type("config/database.xml") # => "application/xml, charset=utf-8"
  # Salt::Mime.content_type(".custom") # => nil
  # ```
  def content_type(extension : String, charset : String = DEFAULT_CHARSET) : String?
    return if extension.empty?
    return unless content_type = lookup(extension)

    "#{content_type}, charset=#{charset.downcase}"
  end

  # Get the default extension for a MIME type.
  #
  # ### Example
  #
  # ```
  # Salt::Mime.extension("application/html") # => "html"
  # ```
  def extension(content_type : String) : String?
    return if content_type.empty?

    if charset?(content_type)
      content_type = content_type.split(",", 2).first.strip
    end

    stores.extensions[content_type]?.try(&.first)
  end

  # Lookup the MIME type for a file path/extension.
  #
  # ### Example
  #
  # ```
  # Salt::Mime.lookup("html") # => "application/html"
  # Salt::Mime.lookup(".html") # => "application/html"
  # Salt::Mime.lookup("config/database.xml") # => "application/xml"
  # Salt::Mime.lookup(".custom") # => nil
  # Salt::Mime.lookup(".custom", "text/plain") # => "text/plain"
  # ```
  def lookup(path : String, default_type : String? = nil) : String?
    return if path.empty?

    extension = ::File.extname("xxx.#{path}").downcase.strip('.')
    return if extension.empty?

    if !(content_type = stores.types[extension]?) && (default = default_type)
      content_type = default
    end

    content_type
  end

  # Get the default charset for a MIME type.
  #
  # ### Example
  #
  # ```
  # Salt::Mime.charset("application/html") # => "utf-8"
  # Salt::Mime.charset("application/html, charset=gbk-2312") # => "gbk-2312"
  # ```
  def charset(content_type : String) : String
    return DEFAULT_CHARSET if content_type.empty?

    charset = DEFAULT_CHARSET
    if charset?(content_type)
      _, value = content_type.downcase.split("charset", 2)
      value = value.strip.strip('=').strip
      charset = value unless value.empty?
    end

    charset
  end

  # :nodoc:
  private def charset?(content_type : String)
    content_type.downcase.includes?("charset")
  end

  # :nodoc:
  private def stores
    @@stores ||= begin
      types = Hash(String, String).new
      extensions = Hash(String, Array(String)).new

      MIME_TYPES.each do |_type, _extensions|
        extensions[_type] ||= Array(String).new
        _extensions.each do |_extension|
          types[_extension] = _type
          extensions[_type] << _extension
        end
      end
      Mapper.new(types, extensions)
    end.as(Mapper)
  end

  # :nodoc:
  private record Mapper, types : Hash(String, String), extensions : Hash(String, Array(String))
end
