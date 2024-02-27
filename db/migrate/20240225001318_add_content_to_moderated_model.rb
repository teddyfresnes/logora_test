class AddContentToModeratedModel < ActiveRecord::Migration[7.1]
  def change
    add_column :moderated_models, :content, :text
  end
end
