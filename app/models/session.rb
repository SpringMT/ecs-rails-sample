class Session < ApplicationRecord
  SESSION_DURATION = 2.weeks

  validates :user_id, presence: true

  def self.generate!(user_id:, current_time: Time.current)
    session_id = ULID.generate
    session = find_by(user_id: user_id)
    if session
      last_updated_at = session.updated_at
      session.id = session_id
      session.expired_at = current_time + Session::SESSION_DURATION
      session.save!
      { session: session, last_updated_at: last_updated_at }
    else
      session = create!(
        id: session_id,
        user_id: user_id,
        expired_at: current_time + Session::SESSION_DURATION,
      )
      { session: session, last_updated_at: nil }
    end
  end

  def expired?(current_time)
    expired_at <= current_time
  end
end
