# app/controllers/api_controller.rb
class ApiController < ApplicationController
  def handle_action(action)
    request_params = {}
    request_params.merge!(params.to_unsafe_hash).as_json.deep_symbolize_keys!
    interaction = action.run(request_params)
    if interaction.valid?
      render json: {result: interaction.result}, status: :ok
    else
      render json: { errors: interaction.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def self.define_method_for(api)
    define_method api[:name] do
      handle_action(api[:name].split('_').map(&:capitalize).join.constantize)
    end
  end

  # Dynamically define methods for each action
  $API_ACTIONS.each { |api| define_method_for(api) }
end
