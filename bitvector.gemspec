Gem::Specification.new do |spec|
  spec.extensions << 'ext/Rakefile'
  spec.name = "bitvector"
  spec.version = "0.0.1"
  spec.authors = ["Hayato Itsumi"]
  spec.email = "hayato.itsumi@icloud.com"
  spec.summary = %q{BitVector implementation for Ruby with FFI C extension}
  spec.license = %q{Confidential}

  spec.files = %w(bitvector.gemspec) + Dir.glob("{lib,spec,ext}/**/*")
  spec.test_files = Dir.glob("{test,spec,features}")

  spec.add_dependency "rake", "~> 10.4"
  spec.add_dependency "ffi-compiler", "~> 0.1"
end
