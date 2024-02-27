class AddIsAcceptedToModeratedModels < ActiveRecord::Migration[7.1]
  def change
    add_column :moderated_models, :is_accepted, :boolean, default: false
  end
end
