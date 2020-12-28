FactoryBot.define do
  factory :user do
    last_name { Faker::Name.male_last_name }
    first_name { Faker::Name.male_first_name }
    middle_name { I18n.locale == :ru ? Faker::Name.male_middle_name : '' }
    email { 'user@example.com' }
    password { 'user_password' }
  end
end
