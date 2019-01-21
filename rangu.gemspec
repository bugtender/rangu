
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rangu/version"

Gem::Specification.new do |spec|
  spec.name          = "rangu"
  spec.version       = Rangu::VERSION
  spec.authors       = ["Vincent Lin"]
  spec.email         = ["bugtender@gmail.com"]

  spec.summary       = "Paranoid text spacing in Ruby"
  spec.description   = "Insert a white space between FullWidth and HalfWidth characters."
  spec.homepage      = "https://github.com/bugtender/rangu"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
