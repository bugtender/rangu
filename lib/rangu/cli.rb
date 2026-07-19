# frozen_string_literal: true

require "optparse"
require "rangu"

module Rangu
  class CLI
    SUCCESS = 0
    ERROR = 1
    USAGE_ERROR = 2

    def self.run(arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr)
      new(stdin:, stdout:, stderr:).run(arguments)
    end

    def initialize(stdin:, stdout:, stderr:)
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
    end

    def run(arguments)
      options = {}
      parser = option_parser(options)
      positional = parser.parse(arguments.dup)
      return print_help(parser) if options[:help]
      return print_version if options[:version]

      source = resolve_source(options, positional, parser)
      source ? execute(source) : USAGE_ERROR
    rescue OptionParser::ParseError => e
      report_usage(e.message, parser)
      USAGE_ERROR
    end

    private

    def option_parser(options)
      OptionParser.new do |parser|
        parser.banner = "Usage: rangu [TEXT] | --text TEXT | --file PATH"
        parser.summary_width = 24

        parser.on("-t", "--text TEXT", "space the provided text") { |text| options[:text] = text }
        parser.on("-f", "--file PATH", "read and space a UTF-8 file") { |path| options[:file] = path }
        parser.on("-v", "--version", "print the version") { options[:version] = true }
        parser.on("-h", "--help", "show this help") { options[:help] = true }

        parser.separator("")
        parser.separator("With no explicit input, rangu reads standard input. Files are never modified.")
      end
    end

    def resolve_source(options, positional, parser)
      return report_usage("expected at most one TEXT argument", parser) if positional.length > 1

      sources = explicit_sources(options, positional)
      return report_usage("text and file inputs are mutually exclusive", parser) if sources.length > 1
      return sources.first unless sources.empty?

      standard_input_source(parser)
    end

    def explicit_sources(options, positional)
      sources = []
      sources << [:text, options[:text]] if options.key?(:text)
      sources << [:file, options[:file]] if options.key?(:file)
      sources << [:text, positional.first] unless positional.empty?
      sources
    end

    def standard_input_source(parser)
      input = @stdin.read
      return report_usage("no input provided", parser) if input.empty?

      [:text, input]
    end

    def execute(source)
      mode, value = source
      result = mode == :file ? Rangu.spacing_file(value) : Rangu.spacing(value)
      @stdout.puts(result)
      SUCCESS
    rescue SystemCallError, IOError, EncodingError, ArgumentError => e
      @stderr.puts("rangu: #{e.message}")
      ERROR
    end

    def print_help(parser)
      @stdout.puts(parser)
      SUCCESS
    end

    def print_version
      @stdout.puts(VERSION)
      SUCCESS
    end

    def report_usage(message, parser)
      @stderr.puts("rangu: #{message}")
      @stderr.puts(parser.banner)
      nil
    end
  end
end
