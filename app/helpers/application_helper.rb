require 'rest_client'

module ApplicationHelper

  def self.get_user_id_moltin(parameters)
    response = RestClient.post("https://#{Moltin::Config::api_host}/v1/customers", {
        :first_name => parameters['user_name'],
        :last_name => parameters['user_last_name'],
        :email => parameters['email']
    }, {:Authorization => "Bearer #{AdminHelper.generate_token}"})
    JSON.parse(response.body)['result']['id']
  end

end
