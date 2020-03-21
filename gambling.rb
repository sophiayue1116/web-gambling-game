require "dm-core"
require "dm-migrations"


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gambling.db")

class Gambling
  include DataMapper::Resource

  property :id, Serial
  property :username, Text
  property :password, Text
  property :win, Integer, default: 0
  property :loss, Integer, default: 0
  property :profit, Integer, default: 0

end

DataMapper.finalize

#DataMapper.auto_upgrade!


