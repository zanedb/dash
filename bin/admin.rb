puts "Enter admin email address: "
email = STDIN.gets.strip.downcase || 'dash@zane.sh'

user = User.invite!(email: email) do |u|
  u.skip_invitation = true
end
user.make_admin!

puts "Created admin user with email #{email}"
puts "\nIMPORTANT:\n=========================\nClick this link (once the server is up) to finish your account: http://localhost:3000/users/invitation/accept?invitation_token=#{user.raw_invitation_token}\n========================="
