class AddAccounts < ActiveRecord::Migration
  def change
    create_table :accounts, :force => true do |t|
      t.references :user
      t.timestamps
    end
  end
end