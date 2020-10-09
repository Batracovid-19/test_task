class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :base, null: false, default: 'EUR'
      t.string :date, null: false
      t.decimal :usd, precision: 15, scale: 7, null: false
      t.decimal :uah, precision: 15, scale: 7, null: false
      t.decimal :rub, precision: 15, scale: 7, null: false
      t.decimal :ron, precision: 15, scale: 7, null: false

      t.timestamps
    end
  end
end
