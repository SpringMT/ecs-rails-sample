require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

require_relative "../lib/rack/exception_handler"
require_relative "../lib/rack/json_structured_logs"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Oj.optimize_rails

module EcsRailsSample
  class Application < Rails::Application
    # https://railsguides.jp/rails_on_rack.html
    # 不要なmiddlewareは消す
    # ETagヘッダ使わないので削除
    config.middleware.delete Rack::ETag
    # Conditional GET使わない
    config.middleware.delete Rack::ConditionalGet
    # config.middleware.delete ActionDispatch::Cookies
    # Active Recordのクエリキャッシュはいらない
    config.middleware.delete ActiveRecord::QueryCache
    # Render error page if config.action_dispatch.show_detailed_exceptions is true
    config.middleware.delete ActionDispatch::DebugExceptions
    # Show error page if config.action_dispatch.show_exceptions is true
    # https://qiita.com/r7kamura/items/2e88adbdd1782277b2e7
    # https://qiita.com/r7kamura/items/1435823b1703df0402ee
    config.middleware.delete ActionDispatch::ShowExceptions
    config.middleware.delete ActionDispatch::ActionableExceptions
    config.middleware.delete ActiveRecord::Migration::CheckPending
    config.middleware.insert_before(0, Rack::JsonStructuredLogs, $stdout)
    config.middleware.insert_before(0, Rack::ExceptionHandler)

    # デフォルトのHTTPヘッダーを削除
    config.action_dispatch.default_headers.clear

    config.active_record.migration_error = false
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.colorize_logging = false
    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/lib]
  end
end
