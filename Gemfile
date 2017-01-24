source ENV['GEM_SOURCE'] || 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'simplecov-console', :require => false
gem 'simplecov', :require => false
gem 'rspec-puppet', :require => false
gem 'rspec-puppet-facts', :require => false
gem 'puppetlabs_spec_helper', '>= 1.2.0', :require => false
gem 'facter', '>= 1.7.0', :require => false
gem 'puppet-lint', '~> 2.0', :require => false
gem 'puppet-lint-absolute_classname-check', :require => false
gem 'puppet-lint-alias-check', :require => false
gem 'puppet-lint-classes_and_types_beginning_with_digits-check', :require => false
gem 'puppet-lint-empty_string-check', :require => false
gem 'puppet-lint-file_ensure-check', :require => false
gem 'puppet-lint-file_source_rights-check', :require => false
gem 'puppet-lint-leading_zero-check', :require => false
gem 'puppet-lint-resource_reference_syntax', :require => false
gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
gem 'puppet-lint-trailing_comma-check', :require => false
gem 'puppet-lint-undef_in_function-check', :require => false
gem 'puppet-lint-unquoted_string-check', :require => false
gem 'puppet-lint-variable_contains_upcase', :require => false
gem 'puppet-lint-version_comparison-check', :require => false

# Rack if a dependency of github_changelog_generator
gem 'github_changelog_generator', require: false
gem 'rack', '~> 1.0', :require => false if RUBY_VERSION <= '2.2.2'
gem 'rack', :require => false if RUBY_VERSION > '2.2.2'

gem 'rspec',     '~> 2.0', :require => false   if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'rake',      '~> 10.0', :require => false  if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'json',      '<= 1.8', :require => false   if RUBY_VERSION < '2.0.0'
gem 'json_pure', '<= 2.0.1', :require => false if RUBY_VERSION < '2.0.0'
gem 'rubocop', :require => false               if RUBY_VERSION >= '2.2.0'
gem 'metadata-json-lint', '0.0.11', :require => false if RUBY_VERSION < '1.9'
gem 'metadata-json-lint', :require => false           if RUBY_VERSION >= '1.9'
gem 'activesupport', :require => false            if RUBY_VERSION >= '2.2.0'
gem 'activesupport', '4.2.7.1', :require => false if RUBY_VERSION < '2.2.0'
