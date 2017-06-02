# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


relationships = [
  "Choose one or create your own",
  "Mother / Father",
  "Grandparent (Mother's side)",
  "Grandparent (Father's side)",
  "Aunt / Uncle (Mother's side)",
  "Aunt / Uncle (Father's side)",
  "Sister / Brother",
  "Cousin (Mother's side)",
  "Cousin (Father's side)",
  "Wedding Party"
  ]

relationships.each do |r|
  Relationship.create(name: r, universal: true)
end
