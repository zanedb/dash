# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "\n== Configuring database with sample data =="

event = Event.create!(name: 'Hack the Universe', start_date: 2.days.ago, end_date: 1.days.ago, city: 'Hack City, CA')

puts "Created event #{event.name}"

100.times do |index|
  event.attendees.create!(first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.email,
                created_at: Faker::Time.between(2.months.ago, 1.week.ago))
end

puts "Created #{event.attendees.count} attendees for #{event.name}"

puts "Enter admin email address: "
email = STDIN.gets.strip.downcase || 'dash@zane.sh'

user = User.invite!(email: email) do |u|
  u.skip_invitation = true
end
user.make_admin!

puts "Created admin user with email #{email}"
puts "\nIMPORTANT:\n=========================\nClick this link (once the server is up) to finish your account: http://localhost:3000/users/invitation/accept?invitation_token=#{user.raw_invitation_token}\n========================="