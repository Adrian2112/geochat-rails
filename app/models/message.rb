class Message
  include MongoMapper::Document
  key :text, String
  key :place_id, String
  timestamps!

  PRIVATE_ATTRIBUTES = [:user_id]

  belongs_to :user

  def as_json(options)
    super(options.merge({
      except: PRIVATE_ATTRIBUTES,
      include: {
        user: { only: User::PUBLIC_ATTRIBUTES } 
      }
    }))
  end
end
