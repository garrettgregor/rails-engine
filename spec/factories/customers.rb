# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    result { [0, 1].sample }
    credit_card_number { Faker::Finance.credit_card }
    invoice
  end
end
