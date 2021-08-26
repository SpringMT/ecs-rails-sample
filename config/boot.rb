ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

stage = ENV.fetch('APP_STAGE', 'local')
path = File.join('config', 'stage_settings', stage)
raise "#{path} is not a directory." unless File.exist?(path)

FileUtils.cp_r(Dir.glob("#{path}/*"), File.join('config'))
