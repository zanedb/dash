# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

event = Event.create!(name: 'Hack the Universe', start_date: 2.days.ago, end_date: 1.days.ago, city: 'Hack City, CA')

p "Created event #{event.name}"

100.times do |index|
  event.attendees.create!(first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.email,
                created_at: Faker::Time.between(2.months.ago, 1.week.ago))
end

p "Created #{event.attendees.count} attendees for #{event.name}"