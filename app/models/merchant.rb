# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.search(query)
    where("name ILIKE ?", "%#{query}%").first
  end

  def self.search_all(query)
    where("name ILIKE ?", "%#{query}%")
  end
end
