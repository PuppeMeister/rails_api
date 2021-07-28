class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :userEmail
      t.integer :projectType
      t.string :title
      t.string :description
      t.string :location
      t.string :thumbnail
      t.timestamps
    end
  end
end
