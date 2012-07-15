class User
  include MongoMapper::Document

  key :name, String
  key :gender, String
  key :photo, String
  key :foursquare_id, Integer
  key :email, String
  key :token, String

  timestamps!

  def self.from_omniauth(auth)
    where(foursquare_id: auth.uid.to_i).first || create_from_omniauth(auth)    
  end
  
  def self.create_from_omniauth(auth)
    info = auth['extra']["raw_info"]
    user = User.new
    user.foursquare_id = auth.uid.to_i
    user.name = [info["firstName"], info["lastName"]].join(" ")
    user.photo = info['photo']
    user.gender = info['gender']
    user.token = auth['credentials']['token']
    user.save
    user
  end

end
