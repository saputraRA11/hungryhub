require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/auth/register' do
    post('register user') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response(201, 'Created') do
        let(:user) { { email: 'test@example.com', password: 'Password123!' } }
        run_test! do |response|
          true
        end
      end

      response(400, 'Bad Request') do
        let(:user) { { email: 'bad' } }
        run_test! do |response|
          true
        end
      end
    end
  end

  path '/api/v1/auth/login' do
    post('login user') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'OK') do
        let(:credentials) { { email: 'test@example.com', password: 'Password123!' } }
        run_test! do |response|
          true
        end
      end

      response(401, 'Unauthorized') do
        let(:credentials) { { email: 'wrong', password: 'password' } }
        run_test! do |response|
          true
        end
      end
    end
  end
end
