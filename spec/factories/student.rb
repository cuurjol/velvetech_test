FactoryBot.define do
  factory :student do
    last_name { Faker::Name.female_last_name }
    first_name { Faker::Name.female_first_name }
    middle_name { I18n.locale == :ru ? Faker::Name.female_middle_name : '' }
    gender { 'female' }
    suid { Faker::IDNumber.valid }
  end
end
