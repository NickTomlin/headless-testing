require "headless"
require "open-uri"

APPLICATION_PORT = ENV["NODE_PORT"] || 4567
APPLICATION_HOST = ENV["NODE_HOST"] || "localhost"
SAUCE_FLAG = "USE_SAUCE"

class ServerRunner
  def run
    @pid = fork do
      begin
        `node .`
      rescue Errno::EADDRINUSE
        puts "#{@port} is already running"
      ensure
        exit! # don't run Headless' at_exit in the child process
      end
    end
  end

  def kill
    `pkill -P #{@pid}`
  end
end

if ENV.has_key?(SAUCE_FLAG)
  require 'sauce'
  require 'sauce/capybara'

  Sauce.config do |c|
    c[:job_name] = "Headless"
    c[:application_host] = APPLICATION_HOST
    c[:application_port] = APPLICATION_PORT
    c[:start_local_application] = false
    c[:start_tunnel] = true
    c[:max_duration] = 1000
    c[:browsers] = [
      ["Windows 7", "iehta", "9"],
    ]
  end
end

require "capybara"

Capybara.app_host = "http://#{APPLICATION_HOST}:#{APPLICATION_PORT}"
Capybara.run_server = false

Capybara.register_driver :firefox_headless do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end


Capybara.default_driver = :firefox_headless
Capybara.javascript_driver = :firefox_headless
headless, node_server = nil

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
	conf.include Capybara::DSL

  conf.before(:suite) do
    # this should run headlessly on most *nix flavors with Xfvb
    headless = Headless.new
    headless.start

    node_server = ServerRunner.new
    node_server.run
  end

  conf.after(:suite) do
    headless.stop if headless.respond_to?(:stop)
    node_server.kill if node_server.respond_to?(:kill)
  end

  conf.before(:each) do
    if ENV.has_key?(SAUCE_FLAG)
      driver = :sauce

      Capybara.current_driver = driver
      Capybara.javascript_driver = driver
    end
  end
end
