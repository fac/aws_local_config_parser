# frozen_string_literal: true

require_relative 'lib/aws_local_config_parser/version'

Gem::Specification.new do |spec|
  spec.name = 'aws_local_config_parser'
  spec.version = AwsLocalConfigParser::VERSION
  spec.authors = ['Dale Morgan']
  spec.email = ['Dale.Morgan@freeagent.com']

  spec.summary = 'A simple gem to parse your local AWS config file.'
  spec.description = "Parse your local '\"$HOME\"/.aws/config' file."
  spec.homepage = 'https://github.com/dmorgan-fa/aws_local_config_parser'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/fac'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  spec.files = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE.txt', '*.md']

  spec.require_paths = ['lib']

  spec.add_dependency 'inifile', '~> 3'
end
