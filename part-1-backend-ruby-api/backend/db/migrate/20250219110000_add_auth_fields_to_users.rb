# frozen_string_literal: true

class AddAuthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
  end
end
