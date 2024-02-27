# app/models/concerns/moderable.rb

# concern de modération

require 'net/http'
require 'json'


module Moderable
	extend ActiveSupport::Concern

	def check_api_status
		uri = URI('https://moderation.logora.fr/') # status de l'api: /
		response = Net::HTTP.get_response(uri)
		if response.is_a?(Net::HTTPSuccess)
		result = JSON.parse(response.body)
			puts "API Status: #{result['status']}"
		else
			puts "API Error: #{response.code}"
		end
	end

	def moderate_content
		uri = URI('https://moderation.logora.fr/predict') # prédiction contenu accepté ou non: /predict
		params = {text: content, language: 'fr-FR'}
		uri.query = URI.encode_www_form(params)
		response = Net::HTTP.get_response(uri)
		if response.is_a?(Net::HTTPSuccess)
			result = JSON.parse(response.body)
			prediction = result['prediction']['0']
		
			puts "Prediction: #{result['prediction']['0']}"
			
			if prediction < 0.5
				is_accepted = true	# predict de rejet <50%, contenu accepté
			else
				is_accepted = false # predict de rejet >50%, contenu accepté
			end

			update(is_accepted: is_accepted) # maj du contenu accepté ou non
		else
			puts "Error: #{response.code}"
		end
	end

end