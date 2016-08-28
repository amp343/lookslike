require 'byebug'
require "lookslike/version"
require "lookslike/validator"
require "lookslike/validation_rule"
require "lookslike/errors/validation_error"
Dir[File.dirname(__FILE__) + '/lookslike/errors/*.rb'].each { |file| require file }

module Lookslike
end
