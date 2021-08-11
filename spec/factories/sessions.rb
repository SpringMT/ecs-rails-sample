FactoryBot.define do
  factory :session do
    sequence(:id) {|n| "session_#{n}" }

    trait :active do
      expired_at { Time.current.since(1.day) }
    end

    trait :expired do
      expired_at { Time.current.ago(1.hour) }
    end
  end
end
