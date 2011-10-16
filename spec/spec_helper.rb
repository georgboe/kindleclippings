$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'kindleclippings'
require 'date'
require 'rspec'
require 'rubygems' if RUBY_VERSION < "1.9.1"
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end
