# README

Première expérience avec Ruby on Rails

### Ruby version
Ruby 3.2.3  
Rails 7.1.3.2  
  
### System dependencies  
si rails n'est pas installé  
`gem install rails`  
  
### Creation projet
`rails new logora_test`  
  
### Création DB
génération du modèle  
`rails generate model ModeratedModel`  
ajout de la colonne is_accepted de type booléen avec une convention de nommage pour la migration  
`rails generate migration AddIsAcceptedToModeratedModel is_accepted:boolean:default:false`  
crée un nouveau model  
`rails generate migration AddContentToModeratedModel content:text`  
`rails db:migrate`  
affiche le dump dans le fichier db/schema  
`rails db:schema:dump`  
## Module moderable.rb
```rb
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
```
## Inclusion du module dans le modèle
```rb
# app/models/moderated_model.rb
class ModeratedModel < ApplicationRecord
	include Moderable
end
```
  
### Test communication avec l'api de modération Logora  
`rails console`  
instance de moderated_model  
`irb(main):001>` `moderated_model = ModeratedModel.new(content: "Texte à modérer")`   
enregistrement dans la db du nouveau content  
`irb(main):001>` `moderated_model.save`   
test status API  
`irb(main):001>` `moderated_model.check_api_status`  
affichage du résultat de l'api  
`irb(main):001>` `moderated_model.moderate_content`  
affichage de tout les models générés  
`irb(main):001>` `ModeratedModel.all`  
affichage des col is_accepted et content seulement  
`irb(main):001>` `ModeratedModel.pluck(:is_accepted, :content)`  
supprimer tout les models générés  
`irb(main):001>` `ModeratedModel.destroy_all`  
  
### Informations  
`rails server` accessible sur http://127.0.0.1:3000/  
