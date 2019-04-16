class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.uuid :household_token, type: :uuid
      t.text :location

      t.timestamps
    end
  end
end
