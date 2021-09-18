require "time"
require "json"

module Rack
  class JsonStructuredLogs
    DEFAULT_PARAMS_PROC = proc do |env, status, headers, _body, began_at|
      now = Time.now # rubocop:disable Rails/TimeZone
      reqtime = now.instance_eval { to_i + (usec / 1_000_000.0) } - began_at
      status_int = status ? status.to_s[0..2].to_i : 500
      severity = if status_int < 400
                   "INFO"
                 elsif status_int < 500
                   "WARNING"
                 else
                   "ERROR"
                 end
      {
        severity: severity,
        time: now.iso8601,
        request_id: env["action_dispatch.request_id"] || "",
        request_method: env["REQUEST_METHOD"],
        request_url: env["REQUEST_URI"],
        request_size: env["CONTENT_LENGTH"].to_s || "0",
        status: status_int,
        response_size: (headers && headers["Content-Length"]) ? headers["Content-Length"].to_s : "0",
        user_agent: env["HTTP_USER_AGENT"] || "",
        remote_ip: ForwardedIp.forwarded_ip(env["HTTP_X_FORWARDED_FOR"]) || "",
        serverIp: env["REMOTE_ADDR"] || "",
        referer: env["HTTP_REFERER"] || "",
        latency: "%0.6fs" % reqtime,
        protocol: env["HTTP_VERSION"],
        session_id: env["app.session_id"] || env["HTTP_AUTHORIZATION"]&.split(" ")&.last || "",
        user_id: env["app.user_id"] || "",
        app_version: env["HTTP_X_APP_VERSION"] || "",
        os: env["HTTP_X_OS"] || "",
        os_version: env["HTTP_X_OS_VERSION"] || "",
        device_id: env["HTTP_X_DEVICE_ID"] || "",
        model: env["HTTP_X_MODEL"] || "",
        uuid: env["HTTP_X_UUID"] || "",
        controller_and_action: env["app.controller_and_action"] || "",
        latency_ms: (reqtime * 1000).to_i,
        error_class: env["app.error_class"] || "",
      }
    end

    def initialize(app, io = nil, **kwargs)
      @app = app
      @io = io || $stdout
      @params_proc = kwargs[:params_proc] || DEFAULT_PARAMS_PROC
    end

    def call(env)
      began_at = Time.now.instance_eval { to_i + (usec / 1_000_000.0) } # rubocop:disable Rails/TimeZone
      status, headers, body = @app.call(env)
    ensure
      params = @params_proc.call(env, status, headers, body, began_at)
      @io.write("#{params.to_json}\n")
    end
  end
end
