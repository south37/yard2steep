
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yard2steep/version"

Gem::Specification.new do |spec|
  spec.name          = "yard2steep"
  spec.version       = Yard2steep::VERSION
  spec.authors       = ["Nao Minami"]
  spec.email         = ["south37777@gmail.com"]

  spec.summary       = %q{Generate steep type definition from yard annotation.}
  spec.description   = %q{Generate steep type definition from yard annotation.}
  spec.homepage      = "https://github.com/south37/yard2steep"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
