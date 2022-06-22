require 'sinatra'
require 'httparty'

set :public_folder, "#{__dir__}/static"

API_KEY = ENV["API_KEY"]
TENANT = ENV["TENANT"]

API_URL = TENANT ? "api-oyster-eu.merge.dev" : "api.merge.dev"

# Replace api_key with your organization's production API Key
def create_link_token
  uri = URI("https://#{API_URL}/api/integrations/create-link-token")
  body = {
    'end_user_origin_id' => "oyster-dev", # unique entity ID
    'end_user_organization_name' => "dev team", # your user's organization name
    'end_user_email_address' => "developers@oysterhr.com", # your user's email address
    'categories' => ["hris"], # choose your category
    'integration' => 'hibob'
  }
  headers = { 'Authorization' => "Bearer #{API_KEY}", 'Content-Type' => 'application/json' }

  link_token_response = HTTParty.post(uri, body: body.to_json, headers: headers)

  puts link_token_response
  link_token_response['link_token']
end

def retrieve_account_token(public_token)
  uri = URI("https://#{API_URL}/api/integrations/account-token/#{public_token}")
  headers = { 'Authorization' => "Bearer #{API_KEY}", 'Content-Type' => 'application/json' }

  HTTParty.get(uri, headers: headers)
end


get '/' do
  @link_token = create_link_token
  @is_tenant = TENANT
  @api_url = API_URL
  erb :index
end

post '/account-key' do
  key = JSON.parse request.body.read
  content_type "application/json"
  retrieve_account_token(key).to_json
end
