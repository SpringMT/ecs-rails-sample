class ApplicationController < ActionController::API
  private def current_time
    @current_time ||= Time.current
  end
end
