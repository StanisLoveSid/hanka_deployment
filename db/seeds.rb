Year.destroy_all

user = User.create(email: 'seeder@mail.com', password: '12345678')
year = Year.create(user_id: user.id, year_number: 2007)
month = Month.create(month_name: 'October', user_id: user.id, year_id: year.id)

31.times { |number| Day.create(month_id: month.id, day_number: number, user_id: user.id) }

month.days.each do |day|
  600.times { SugarLevel.create(day_id: month.days.first.id, 
                    mmol: rand(2.8..19.1), 
                    created_at: "#{month.days.first.created_at.day}.#{month.created_at.month}.#{year.created_at.year} #{rand(1..23)}:#{rand(1..59)}") }
end
