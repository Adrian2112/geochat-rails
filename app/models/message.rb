class Message
  include MongoMapper::Document
  key :text, String
  key :place_id, String
  timestamps!

  belongs_to :user


end
