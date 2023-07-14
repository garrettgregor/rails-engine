# frozen_string_literal: true

require 'rails_helper'

describe 'Items API' do
  context 'happy path' do
    it 'sends a list of items' do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)

      get api_v1_items_path

      expect(response).to have_http_status(:ok)

      items_data = JSON.parse(response.body, symbolize_names: true)
      items = items_data[:data]

      expect(items.size).to eq(3)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be > 0

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
      end
    end

    it 'can return one item' do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)

      get api_v1_item_path(Item.first)

      expect(response).to have_http_status(:ok)

      item_data = JSON.parse(response.body, symbolize_names: true)
      item = item_data[:data]

      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be > 0

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end

    it 'can create an item' do
      merchant = create(:merchant)

      item_values = {
        "name": 'value1',
        "description": 'value2',
        "unit_price": 100.99,
        "merchant_id": merchant.id
      }

      post '/api/v1/items', params: { item: item_values }

      expect(response).to have_http_status(:created)

      returned_item = JSON.parse(response.body, symbolize_names: true)
      item = returned_item[:data]

      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be > 0

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end

    it 'can update an item' do
      merchant = create(:merchant)
      item_to_update = merchant.items.create!(
        {
          name: 'value1',
          description: 'value2',
          unit_price: 100.99,
          merchant_id: merchant.id
        }
      )

      item_updates = {
        "name": 'test1',
        "description": 'test2'
      }

      patch "/api/v1/items/#{item_to_update.id}", params: { item: item_updates }

      expect(response).to have_http_status(:accepted)

      returned_item = JSON.parse(response.body, symbolize_names: true)
      item = returned_item[:data]

      expect(item).to have_key(:id)
      expect(item[:id].to_i).to eq(item_to_update.id)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq('test1')

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to eq('test2')

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to eq(100.99)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end

    it 'can delete an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
    end

    it 'returns an items merchant' do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)

      get api_v1_item_merchant_index_path(Item.first)

      expect(response).to have_http_status(:ok)

      merchant_data = JSON.parse(response.body, symbolize_names: true)
      retrieved_merchant = merchant_data[:data]

      expect(retrieved_merchant).to have_key(:id)
      expect(retrieved_merchant[:id].to_i).to eq(merchant.id)

      expect(retrieved_merchant).to have_key(:type)
      expect(retrieved_merchant[:type]).to eq('merchant')

      expect(retrieved_merchant).to have_key(:attributes)
      expect(retrieved_merchant[:attributes]).to be_a(Hash)

      expect(retrieved_merchant[:attributes]).to have_key(:name)
      expect(retrieved_merchant[:attributes][:name]).to be_a(String)
      expect(retrieved_merchant[:attributes][:name]).to eq(merchant.name)
    end

    xit "can delete an items' associated invoice" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      # add invoice

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'sad path' do
    it 'bad integer id returns 404 for wrong id getting an item' do
      get api_v1_item_path(120_987_234_587_090)

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'edge case' do
    it 'bad integer id returns 404 for invalid string getting an item' do
      get api_v1_item_path('hello')

      expect(response).to have_http_status(:not_found)
    end

    xit 'bad merchant id returns 404 when updating' do
      merchant = create(:merchant)
      item_to_update = merchant.items.create!(
        {
          name: 'value1',
          description: 'value2',
          unit_price: 100.99,
          merchant_id: 120_987_234_587_090
        }
      )

      item_updates = {
        "name": 'test1',
        "description": 'test2'
      }

      patch "/api/v1/items/#{item_to_update.id}", params: { item: item_updates }

      expect(response).to have_http_status(:not_found)
    end
  end
end
