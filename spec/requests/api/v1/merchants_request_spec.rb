require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get api_v1_merchants_path

    expect(response).to have_http_status(:ok)

    merchants_data = JSON.parse(response.body, symbolize_names: true)
    merchants = merchants_data[:data]

    expect(merchants.size).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)
      # ^^Question: Should this be written another way? Should this be coming back as an integer after serializing?

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      ## Question: should we be enabling relationships and foregoing the postman tests?
      ## Enabling relationships for merchant and item serializer will make these pass:
      # expect(merchant).to have_key(:relationships)
      # expect(merchant[:relationships]).to be_a(Hash)

      # expect(merchant[:relationships]).to have_key(:items)
      # expect(merchant[:relationships][:items]).to be_a(Hash)

      # expect(merchant[:relationships][:items]).to have_key(:data)
      # expect(merchant[:relationships][:items][:data]).to be_an(Array)
    end
  end

  it "can return a one merchant" do
    merchant = create(:merchant)

    get api_v1_merchant_path(merchant)

    expect(response).to have_http_status(:ok)

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to be_an(Integer)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)

    # expect(merchant).to have_key(:relationships)
    # expect(merchant[:relationships]).to be_a(Hash)

    # expect(merchant[:relationships]).to have_key(:items)
    # expect(merchant[:relationships][:items]).to be_a(Hash)

    # expect(merchant[:relationships][:items]).to have_key(:data)
    # expect(merchant[:relationships][:items][:data]).to be_an(Array)
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
      expect(item[:type]).to eq("item")

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

      # expect(merchant).to have_key(:relationships)
      # expect(merchant[:relationships]).to be_a(Hash)

      # expect(merchant[:relationships]).to have_key(:items)
      # expect(merchant[:relationships][:items]).to be_a(Hash)

      # expect(merchant[:relationships][:items]).to have_key(:data)
      # expect(merchant[:relationships][:items][:data]).to be_an(Array)
    end
  end
end