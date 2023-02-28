# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create! :email => 'admin@rails101.org', :password => 'P@ssw0rd9999', :password_confirmation => 'P@ssw0rd9999'
5.times do |i|
  Board.create(name: "board ##{i+1}", user_id: 1)
  2.times do |j|
    Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}", board_id: i+1)
  end
end 
