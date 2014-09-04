class FillNewRelicAccounts < ActiveRecord::Migration
  def up
    execute "
      INSERT INTO accounts (id, name, api_key)
     VALUES (531582, 'Mobicare', '6eaa989289b998bef504044122bf943c7007fbddb09db95'),
            (687286, 'Cielo', 'c40c13477309fc261dbe2c4d311cd75b6f7e4d9f8f4035c'),
            (700058, 'NET', '2536f61b719d96a796169b9fc64421e5ec91278edfba897')"
  end

  def down
    execute "
      DELETE
        FROM accounts
       WHERE api_key in ( '6eaa989289b998bef504044122bf943c7007fbddb09db95'
                        , 'c40c13477309fc261dbe2c4d311cd75b6f7e4d9f8f4035c'
                        , '2536f61b719d96a796169b9fc64421e5ec91278edfba897')
    "
  end
end
