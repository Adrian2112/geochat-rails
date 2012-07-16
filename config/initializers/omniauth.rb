Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET
end


