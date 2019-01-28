# frozen_string_literal: true

class CreateMessage < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.string :subject
      t.string :body
      t.string :ip_address
      t.timestamps
    end
  end
end
