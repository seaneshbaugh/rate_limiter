class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :first_name, null: false, default: ''
      t.string :last_name,  null: false, default: ''
      t.string :subject,    null: false, default: ''
      t.text :body,         null: false, default: ''
      t.string :ip_address, null: false, default: ''
      t.timestamps
    end

    change_table :messages do |t|
      t.index :ip_address
    end
  end
end
