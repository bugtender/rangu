# frozen_string_literal: true

require "test_helper"
require "rangu/cli"
require "stringio"

class RanguCLITest < Minitest::Test
  def test_spaces_a_positional_text_argument
    status, stdout, stderr = run_cli(["中文Ruby"])

    assert_equal 0, status
    assert_equal "中文 Ruby\n", stdout
    assert_empty stderr
  end

  def test_spaces_an_explicit_text_option
    status, stdout, stderr = run_cli(["--text", "Ruby中文"])

    assert_equal 0, status
    assert_equal "Ruby 中文\n", stdout
    assert_empty stderr
  end

  def test_spaces_an_explicit_file_without_modifying_it
    Tempfile.create("rangu-cli") do |file|
      file.write("中文Ruby")
      file.close

      status, stdout, stderr = run_cli(["--file", file.path])

      assert_equal 0, status
      assert_equal "中文 Ruby\n", stdout
      assert_empty stderr
      assert_equal "中文Ruby", File.read(file.path, encoding: Encoding::UTF_8)
    end
  end

  def test_reads_standard_input_when_no_explicit_input_is_given
    status, stdout, stderr = run_cli([], "中文Ruby")

    assert_equal 0, status
    assert_equal "中文 Ruby\n", stdout
    assert_empty stderr
  end

  def test_explicit_input_takes_priority_over_standard_input
    unreadable_stdin = Object.new
    def unreadable_stdin.read = raise("stdin should not be read")

    status, stdout, stderr = run_cli(["中文Ruby"], unreadable_stdin)

    assert_equal 0, status
    assert_equal "中文 Ruby\n", stdout
    assert_empty stderr
  end

  def test_prints_help_to_standard_output
    status, stdout, stderr = run_cli(["--help"])

    assert_equal 0, status
    assert_includes stdout, "Usage: rangu"
    assert_includes stdout, "Files are never modified."
    assert_empty stderr
  end

  def test_prints_version_to_standard_output
    status, stdout, stderr = run_cli(["--version"])

    assert_equal 0, status
    assert_equal "#{Rangu::VERSION}\n", stdout
    assert_empty stderr
  end

  def test_rejects_text_and_file_options_together
    status, stdout, stderr = run_cli(["--text", "中文Ruby", "--file", "input.txt"])

    assert_equal 2, status
    assert_empty stdout
    assert_includes stderr, "mutually exclusive"
    assert_includes stderr, "Usage: rangu"
  end

  def test_rejects_a_positional_argument_with_an_explicit_mode
    status, stdout, stderr = run_cli(["--text", "中文Ruby", "extra"])

    assert_equal 2, status
    assert_empty stdout
    assert_includes stderr, "mutually exclusive"
  end

  def test_rejects_multiple_positional_arguments
    status, stdout, stderr = run_cli(%w[one two])

    assert_equal 2, status
    assert_empty stdout
    assert_includes stderr, "at most one TEXT"
  end

  def test_rejects_missing_input
    status, stdout, stderr = run_cli([])

    assert_equal 2, status
    assert_empty stdout
    assert_includes stderr, "no input provided"
  end

  def test_reports_unknown_options
    status, stdout, stderr = run_cli(["--unknown"])

    assert_equal 2, status
    assert_empty stdout
    assert_includes stderr, "invalid option"
    assert_includes stderr, "Usage: rangu"
  end

  def test_reports_file_errors
    status, stdout, stderr = run_cli(["--file", "missing-rangu-file.txt"])

    assert_equal 1, status
    assert_empty stdout
    assert_includes stderr, "No such file or directory"
  end

  private

  def run_cli(arguments, input = "")
    stdin = input.respond_to?(:read) ? input : StringIO.new(input)
    stdout = StringIO.new
    stderr = StringIO.new
    status = Rangu::CLI.run(arguments, stdin: stdin, stdout: stdout, stderr: stderr)

    [status, stdout.string, stderr.string]
  end
end
