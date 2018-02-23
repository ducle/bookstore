# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

{
  'IT books' => [
    'Computers',
    'Database',
    'Network',
    'Web development',
    'Mobile development',
  ],
  'Business' => [
    'Startup',
    'Eco system',
    'Macro economics',
    'Micro economics',
    'Management'
  ],
  'Languages' => [
    'English',
    'Chinese',
    'Vietnamese',
    'Japanese',
    'French'
  ]
}.each do |k, v|
  root_cat = Category.create!(name: k)
  v.each do |ct|
    Category.create!(name: ct, parent_id: root_cat.id)
  end
end

