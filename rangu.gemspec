# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rangu/version"

packaged_files = Dir[
  "CHANGELOG.md",
  "CODE_OF_CONDUCT.md",
  "LICENSE",
  "README.md",
  "exe/*",
  "lib/**/*.rb"
].sort

Gem::Specification.new do |spec|
  spec.name = "rangu"
  spec.version = Rangu::VERSION
  spec.authors = ["Vincent Lin"]
  spec.email = ["bugtender@gmail.com"]

  spec.summary = "Paranoid text spacing in Ruby"
  spec.description = "Insert a white space between FullWidth and HalfWidth characters."
  spec.homepage = "https://github.com/bugtender/rangu"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri" => "https://github.com/bugtender/rangu/issues",
    "changelog_uri" => "https://github.com/bugtender/rangu/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bugtender/rangu"
  }
  spec.files = packaged_files
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
