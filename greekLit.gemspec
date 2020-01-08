
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "greekLit/version"

Gem::Specification.new do |spec|
  spec.name          = "greekLit"
  spec.version       = GreekLit::VERSION
  spec.authors       = ["shamangeorge"]
  spec.email         = ["shamangeorge@fruitopology.net"]

  spec.summary       = %q{Write a short summary, because RubyGems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://agora.fruitopology.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  # get an array of submodule dirs by executing 'pwd' inside each submodule
  gem_dir = File.expand_path(File.dirname(__FILE__)) + "/"
  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|
    Dir.chdir(submodule_path) do
      submodule_relative_path = submodule_path.sub gem_dir, ""
			puts "Adding submodule @ #{submodule_relative_path} files to #{spec.name}"
      # issue git ls-files in submodule's directory and
      # prepend the submodule path to create absolute file paths
      `git ls-files`.split($\).each do |filename|
        spec.files << "#{submodule_relative_path}/#{filename}"
      end
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"
  spec.add_dependency "rspec"
  spec.add_dependency "rake"
  spec.add_dependency "pry"
  spec.add_dependency "ox"
  spec.add_dependency "nokogiri"
  spec.add_dependency "activesupport"
  spec.add_dependency "awesome_print"
  spec.add_dependency "greek-i18n"
  spec.add_dependency "elasticsearch"
end
