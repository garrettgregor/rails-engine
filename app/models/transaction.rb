# frozen_string_literal: true

require 'rails_helper'

class Transaction < ApplicationRecord
  validates :invoice_id,
            :credit_card_number,
            :result, presence: true

  belongs_to :invoice
end
