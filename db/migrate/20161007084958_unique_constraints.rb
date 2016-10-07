class UniqueConstraints < ActiveRecord::Migration
  def change
    add_index :organizations, :name, unique: true
    add_index :models, :model_slug, unique: true
    add_index :model_types, :model_type_slug, unique: true
  end
end
