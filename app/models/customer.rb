# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :first_name,
            :last_name, presence: true

  has_many :invoices
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices
end
