class CreateGlucometerBsls < ActiveRecord::Migration[5.0]
  def change
    create_table :glucometer_bsls do |t|
      t.string :email
      t.float :mmol
      t.string :date

      t.timestamps
    end
  end
end
