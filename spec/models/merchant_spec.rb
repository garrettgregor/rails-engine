# frozen_string_literal: true

require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe '.class methods' do
    let!(:merchant_1) { Merchant.create!(name: 'Target') }
    let!(:merchant_2) { Merchant.create!(name: 'Target1') }
    let!(:merchant_3) { Merchant.create!(name: 'Amazon') }

    it 'returns one specific merchant from a search query' do
      expect(Merchant.search('Target')).to eq(merchant_1)
      expect(Merchant.search('aRg')).to eq(merchant_1)
    end

    it 'returns all merchants from a search query' do
      expect(Merchant.search_all('aRg')).to eq([merchant_1, merchant_2])
    end
  end
end
