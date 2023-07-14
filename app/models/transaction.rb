# frozen_string_literal: true

require 'rails_helper'

class Transaction < ApplicationRecord
  validates_presence_of :invoice_id,
                        :credit_card_number,
                        :result

  belongs_to :invoice
end
