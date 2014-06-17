RACK_ENV = 'test' unless defined?(RACK_ENV)
PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
JSON_SECURITY_REGEX = %r{^\s*(while\s*\(\s*1\s*\)\s*\{\s*\})\s*} unless defined? JSON_SECURITY_REGEX
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'pathy'
Object.pathy!

RSpec.configure do |conf|
	conf.include Rack::Test::Methods
	conf.expect_with :rspec do |c|
		c.syntax = [:should, :expect]
	end
	conf.mock_with :rspec do |c|
		c.syntax = [:should, :expect]
	end
end

def app(app = nil, &blk)
	@app ||= block_given? ? app.instance_eval(&blk) : app
	@app ||= Padrino.application
end

class Rack::MockResponse
	def json_body
		JSON.parse(self.body.gsub(JSON_SECURITY_REGEX, ''))
	end
end

module MyCustomMatchers
	RSpec::Matchers.define :be_json do
		match do |response|
			if response.content_type.match(%r{^application/json(;|$)}) &&
			 match_data = response.body.match(JSON_SECURITY_REGEX)
				match_data[1].gsub(/\s+/, '') == 'while(1){}'
			else
				false
			end
		end
		failure_message_for_should do |response|
			"expected that 'Content-Type: #{response.content_type[0..15]}, #{response.body[0..19]}...' would be valid JSON"
		end
	end
end

RSpec.configure { |conf| conf.include MyCustomMatchers }

