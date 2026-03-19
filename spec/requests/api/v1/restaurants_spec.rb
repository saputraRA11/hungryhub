require 'swagger_helper'

RSpec.describe 'api/v1/restaurants', type: :request do
  path '/api/v1/restaurants' do
    get('list restaurants') do
      tags 'Restaurants'
      security [ TokenAuth: [] ]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false

      response(200, 'successful') do
        let(:Authorization) { 'Token token=fake' }
        run_test! do |response|
          true
        end
      end
    end

    post('create restaurant') do
      tags 'Restaurants'
      security [ TokenAuth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string },
          opening_hours: { type: :string }
        },
        required: [ 'name', 'address', 'opening_hours' ]
      }

      response(201, 'created') do
        let(:Authorization) { 'Token token=fake' }
        let(:restaurant) { { name: 'New Place', address: '123 St', opening_hours: '08:00 - 22:00' } }
        run_test! do |response|
          true
        end
      end
    end
  end

  path '/api/v1/restaurants/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'id'

    get('show restaurant') do
      tags 'Restaurants'
      security [ TokenAuth: [] ]
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { 1 }
        let(:Authorization) { 'Token token=fake' }
        run_test! do |response|
          true
        end
      end
    end

    put('update restaurant') do
      tags 'Restaurants'
      security [ TokenAuth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string },
          opening_hours: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { 1 }
        let(:Authorization) { 'Token token=fake' }
        let(:restaurant) { { name: 'Updated Place' } }
        run_test! do |response|
          true
        end
      end
    end

    delete('delete restaurant') do
      tags 'Restaurants'
      security [ TokenAuth: [] ]
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { 1 }
        let(:Authorization) { 'Token token=fake' }
        run_test! do |response|
          true
        end
      end
    end
  end
end
