require "./db"

require "http/client"
require "logger"
require "json"

module Mime
  class Builder
    STANDARD_URL = "https://raw.githubusercontent.com/broofa/node-mime/master/types/standard.json"
    # OTHER_URL = "https://raw.githubusercontent.com/broofa/node-mime/master/types/other.json"

    @raw = JSON::Any.new(nil)

    def initialize(@filename = "db.cr", @logger = Logger.new(STDOUT, Logger::DEBUG), @verbose = false)
      download
      write_to_db if update?
    end

    private def update?
      current_mime_size = Mime::MIME_TYPES.size
      download_mime_size = @raw.as_h.size

      is_updated = (download_mime_size > current_mime_size)

      debug "Current: #{current_mime_size}, Download: #{download_mime_size}"

      if is_updated
        info "New mime types found: #{download_mime_size - current_mime_size}."
      else
        info "Already up to date."
      end

      is_updated
    end

    private def download
      info "Download standard mime types ..."
      response = HTTP::Client.get STANDARD_URL
      unless response.success?
        raise "Download Standard url error (#{response.status_code}), body: #{response.to_s}"
      end

      @raw = JSON.parse response.body
    end

    private def write_to_db
      info "Write to file ... #{file}"

      File.open(file, "w") do |io|
        io << "# Database of Mime" << "\n"
        io << "#" << "\n"
        io << "# Source: #{STANDARD_URL}" << "\n"
        io << "# Updated Date: #{Time.now}" << "\n"
        io << "module Mime" << "\n"
        io << "  MIME_TYPES = {" << "\n"

        @raw.as_h.each do |mime, extensions|
          io << "    \"" << mime.to_s << "\" => ["
          io << extensions.as_a.map {|ext| %Q("#{ext}")}.join(", ")
          io << "], " << "\n"
        end

        io << "  } of String => Array(String)" << "\n"
        io << "end" << "\n"
      end
    end

    private def file
      File.join File.expand_path("../", __FILE__), @filename
    end

    private def debug(message)
      @logger.debug message if @verbose
    end

    private delegate info, to: @logger
  end
end
