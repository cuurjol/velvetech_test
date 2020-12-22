3.times do |i|
  email = "user#{i + 1}@example.com"
  password = "user#{i + 1}_password"
  user_params = if I18n.locale == :ru
                  { last_name: Faker::Name.male_last_name, first_name: Faker::Name.male_first_name,
                    middle_name: Faker::Name.male_middle_name, email: email, password: password }
                else
                  { last_name: Faker::Name.male_last_name, first_name: Faker::Name.male_first_name,
                    email: email, password: password }
                end

  user = User.create(user_params)

  numbers = [0, 1]
  10.times do
    gender_number = numbers.sample
    suid = Faker::IDNumber.valid

    if gender_number.zero?
      student_params = if I18n.locale == :ru
                         { last_name: Faker::Name.male_last_name, first_name: Faker::Name.male_first_name,
                           middle_name: Faker::Name.male_middle_name, gender: gender_number, suid: suid, user: user }
                       else
                         { last_name: Faker::Name.male_last_name, first_name: Faker::Name.male_first_name,
                           gender: gender_number, suid: suid, user: user }
                       end
    else
      student_params = if I18n.locale == :ru
                         { last_name: Faker::Name.female_last_name, first_name: Faker::Name.female_first_name,
                           middle_name: Faker::Name.female_middle_name, gender: gender_number, suid: suid, user: user }
                       else
                         { last_name: Faker::Name.female_last_name, first_name: Faker::Name.female_first_name,
                           gender: gender_number, suid: suid, user: user }
                       end
    end

    Student.create(student_params)
  end
end
