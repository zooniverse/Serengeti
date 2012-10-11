require 'mysql2'

Mysql = Mysql2::Client.new({
  :host => '127.0.0.1',
  :username => 'root',
  :password => 'root',
  :database => 'carnivore_coexistence',
  :cache_rows => false
})
