class CreateModeratedModels < ActiveRecord::Migration[7.1]
  def change
    create_table :moderated_models do |t|

      t.timestamps
    end
  end
end
