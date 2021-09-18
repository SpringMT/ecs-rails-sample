class ApplicationController < ActionController::API
  # 呼び出す順番
  # https://github.com/rails/rails/blob/main/actionpack/lib/abstract_controller/callbacks.rb#L9
  prepend_before_action :set_params_for_logger
  before_action :set_session_id_to_env

  before_action :output_debug_request_information
  before_action :set_controller_and_action_to_env

  private def set_params_for_logger
    # メモリリークする可能性あり
    params_proc = proc do
      {
        request_id: request.env["action_dispatch.request_id"] || "-",
        session_id: request.env["app.session_id"] || "-",
        user_id: request.env["app.user_id"] || "-",
      }
    end
    AppFormatter.global_formatter.params_proc = params_proc
  end

  private def set_session_id_to_env
    request.env["app.session_id"] = session_id
  end

  # access.logに出力するためにenvに含める
  private def set_controller_and_action_to_env
    request.env["app.controller_and_action"] = "#{controller_path}##{action_name}"
  end

  private def set_user_id_to_env(user_id)
    request.env["app.user_id"] = user_id
  end

  private def current_time
    @current_time ||= Time.current
  end

  private def output_debug_request_information
    # header env経由でアクセスするとHTTP経由のものにはHTTP_のprefixがつく
    # https://github.com/rails/rails/blob/main/actionpack/lib/action_dispatch/http/headers.rb
    http_headers = request.headers.env.select {|k, _v| k.start_with?("HTTP_") }
    Rails.logger.debug { "Requst Headers: #{http_headers.to_json}" }
    # body
    Rails.logger.debug { "Requst Parameters: #{request.filtered_parameters.to_json}" }
  end

    private def session_id # rubocop:disable Style/TrivialAccessors
      @session_id
    end

    private def current_user # rubocop:disable Style/TrivialAccessors
      @current_user
    end
end
