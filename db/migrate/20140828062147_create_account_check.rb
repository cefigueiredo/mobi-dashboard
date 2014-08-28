class CreateAccountCheck < ActiveRecord::Migration
  def change
    create_table :account_checks do |t|
      t.references    :account
      t.string        :status
      t.datetime      :date
    end
  end
end
