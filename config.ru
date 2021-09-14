# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# https://kubernetes.io/docs/reference/using-api/health-checks/
use Rack::Health,
    path: "/healthz",
    sick_if: -> { File.exist?(Rails.root.join("tmp/run/maintenance")) }

run Rails.application
Rails.application.load_server
