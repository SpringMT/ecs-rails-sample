class V1::SessionsController < ApplicationController
  def show(id: "")
    session = Session.find(id)
    if session.expired?(current_time)
      raise ArgumentError
    end
    response_data = { user_id: session.user_id, session_id: session.id }
    render json: response_data
  end

  def create(user_id:)
    session = nil
    Session.transaction do
      session = Session.generate!(user_id: user_id, current_time: current_time)
    end
    render json: {session_id: session[:session].id, last_session_updated_at: session[:last_updated_at]}
  end
end
