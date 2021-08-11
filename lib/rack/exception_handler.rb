require "json"
require "action_dispatch/middleware/exception_wrapper"
require "action_dispatch/routing/inspector"

# 大元
# https://github.com/rails/rails/blob/main/actionpack/lib/action_dispatch/middleware/debug_exceptions.rb
# https://r7kamura.com/articles/2014-09-01-q
module Rack
  class ExceptionHandler
    def initialize(app, routes_app = nil)
      @app = app
      @routes_app = routes_app
    end

    def call(env)
      request = ActionDispatch::Request.new env
      _, headers, body = response = @app.call(env)

      if headers["X-Cascade"] == "pass"
        body.close if body.respond_to?(:close)
        raise ActionController::RoutingError, "No route matches from [#{env["REQUEST_METHOD"]}] #{env["PATH_INFO"].inspect}"
      end

      response
    rescue => e
      render_exception(env, request, e)
    end

    private def render_exception(env, request, exception)
      backtrace_cleaner = request.get_header("action_dispatch.backtrace_cleaner")
      wrapper = ActionDispatch::ExceptionWrapper.new(backtrace_cleaner, exception)
      trace = wrapper.application_trace
      trace = wrapper.framework_trace if trace.empty?
      message = "#{exception.class} (#{exception.message})"

      case exception
      when ActionController::RoutingError
        logger(env).warn("#{message} at #{trace.first}")
        [400, { "Content-Type" => "application/json" }, [{ message: message }.to_json]]
      when ActionController::BadRequest
        logger(env).error("#{message} at #{trace.join("   <<<   ")}")
        [400, { "Content-Type" => "application/json" }, [{ message: message }.to_json]]
      else
        logger(env).error("#{message} at #{trace.join("   <<<   ")}")
        [500, { "Content-Type" => "application/json" }, [{ message: message }.to_json]]
      end
    end

    private def logger(env)
      env["action_dispatch.logger"] || stdout_logger
    end

    private def stdout_logger
      $stdout.sync = true
      @stdout_logger ||= ActiveSupport::Logger.new($stdout)
    end
  end
end
