class AddUsers < ActiveRecord::Migration
  def change
    create_table :users, :force => true do |t|
      t.datetime :last_request_at
    end
  end
end