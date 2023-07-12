# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Coffee.variety }
    description { Faker::Hipster.sentence }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    # merchant
  end
end
