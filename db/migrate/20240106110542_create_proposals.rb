class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals do |t|
      t.string :pdf
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
