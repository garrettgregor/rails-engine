# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name,
            :description,
            :unit_price,
            :merchant_id, presence: true

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant
end
