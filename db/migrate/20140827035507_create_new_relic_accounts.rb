class CreateNewRelicAccounts < ActiveRecord::Migration
  def up
    create_table :new_relic_accounts do |t|
      t.integer   :id
      t.string    :name
      t.string    :api_key
    end
  end

  def down
    drop_table :new_relic_accounts
  end
end
