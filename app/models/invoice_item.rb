# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  validates :invoice_id,
            :item_id,
            :quantity,
            :unit_price, presence: true

  belongs_to :invoice
  belongs_to :item
end
