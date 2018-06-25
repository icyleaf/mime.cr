require "./builder"
require "option_parser"

module Mime
  class Cli
    @verbose = false
    @show_help = false

    def initialize
      OptionParser.parse! do |parser|
        parser.banner = "Usage: mime_builder"
        parser.on("-V", "--verbose", "Verbose mode (default is false)") { @verbose = true }
        parser.on("-h", "--help", "Show this help") { @show_help = true; puts parser }
      end
    end

    def run
      Mime::Builder.new(verbose: @verbose) unless @show_help
    end
  end
end
