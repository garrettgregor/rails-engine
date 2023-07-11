require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants_data = JSON.parse(response.body, symbolize_names: true)
    merchants = merchants_data[:data]

    expect(merchants.size).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      ## Enabling relationships for merchant and item serializer will make these pass
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

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

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

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

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
end