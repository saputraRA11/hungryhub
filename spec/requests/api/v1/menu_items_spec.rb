require 'swagger_helper'

RSpec.describe 'api/v1/menu_items', type: :request do
  path '/api/v1/restaurants/{restaurant_id}/menu_items' do
    parameter name: :restaurant_id, in: :path, type: :integer, description: 'restaurant_id'

    get('list menu items') do
      tags 'Menu Items'
      security [ TokenAuth: [] ]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false
      parameter name: :category, in: :query, type: :string, description: 'Filter by category', required: false
      parameter name: :search, in: :query, type: :string, description: 'Filter by name', required: false

      response(200, 'successful') do
        let(:restaurant_id) { 1 }
        let(:Authorization) { 'Token token=fake' }
        run_test! do |response|
          true
        end
      end
    end

    post('create menu item') do
      tags 'Menu Items'
      security [ TokenAuth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :menu_item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          price: { type: :number, format: :float },
          category: { type: :string, enum: ['appetizer', 'main', 'dessert', 'drink'] },
          is_available: { type: :boolean }
        },
        required: [ 'name', 'description', 'price', 'category', 'is_available' ]
      }

      response(201, 'created') do
        let(:restaurant_id) { 1 }
        let(:Authorization) { 'Token token=fake' }
        let(:menu_item) { { name: 'Item', description: 'Desc', price: 10.0, category: 'main', is_available: true } }
        run_test! do |response|
          true
        end
      end
    end
  end
end
