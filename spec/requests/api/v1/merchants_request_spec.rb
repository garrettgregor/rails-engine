# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants API' do
  context 'happy path' do
    it 'sends a list of merchants' do
      create_list(:merchant, 3)

      get api_v1_merchants_path

      expect(response).to have_http_status(:ok)

      merchants_data = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_data[:data]

      expect(merchants.size).to eq(3)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'can return a one merchant' do
      merchant = create(:merchant)

      get api_v1_merchant_path(merchant)

      expect(response).to have_http_status(:ok)

      merchant_data = JSON.parse(response.body, symbolize_names: true)
      merchant = merchant_data[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    it "can return a specific merchant's items" do
      merchant = create(:merchant)
      create_list(:item, 5, merchant_id: merchant.id)

      get api_v1_merchant_items_path(merchant)

      expect(response).to have_http_status(:ok)

      merchant_items_data = JSON.parse(response.body, symbolize_names: true)
      items = merchant_items_data[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    it 'can find a single merchant which matches a search term' do
      merchant = create(:merchant, name: 'Target')

      get '/api/v1/merchants/find?name=Target'
      expect(response).to have_http_status(:ok)

      merchant_data = JSON.parse(response.body, symbolize_names: true)
      returned_merchant = merchant_data[:data]

      expect(returned_merchant).to have_key(:id)
      expect(returned_merchant[:id].to_i).to eq(merchant.id)

      expect(returned_merchant).to have_key(:type)
      expect(returned_merchant[:type]).to eq('merchant')

      expect(returned_merchant).to have_key(:attributes)
      expect(returned_merchant[:attributes]).to be_a(Hash)

      expect(returned_merchant[:attributes]).to have_key(:name)
      expect(returned_merchant[:attributes][:name]).to be_a(String)
      expect(returned_merchant[:attributes][:name]).to eq(merchant.name)
    end

    it 'can find all merchants that match a search term' do
      create(:merchant, name: 'Target')
      create(:merchant, name: 'Target1')

      get '/api/v1/merchants/find_all?name=Target'
      # Question: use 302?
      expect(response).to have_http_status(:ok)

      merchants_data = JSON.parse(response.body, symbolize_names: true)
      returned_merchants = merchants_data[:data]

      returned_merchants.each do |returned_merchant|
        expect(returned_merchant).to have_key(:id)
        expect(returned_merchant[:id].to_i).to be_an(Integer)

        expect(returned_merchant).to have_key(:type)
        expect(returned_merchant[:type]).to eq('merchant')

        expect(returned_merchant).to have_key(:attributes)
        expect(returned_merchant[:attributes]).to be_a(Hash)

        expect(returned_merchant[:attributes]).to have_key(:name)
        expect(returned_merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  context 'sad path' do
    it 'bad integer id returns 404 for getting a merchant' do
      get api_v1_merchant_path(120_987_234_587_090)

      expect(response).to have_http_status(:not_found)
    end

    it "bad integer id returns 404 for getting a merchant's items" do
      merchant = create(:merchant)
      create_list(:item, 5, merchant_id: merchant.id)

      get api_v1_merchant_items_path(120_987_234_587_090)

      expect(response).to have_http_status(:not_found)
    end
  end
end
