case Rails.env
when "development"
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['DEV_FACEBOOK_KEY'], ENV['DEV_FACEBOOK_SECRET']
  end
when "production"
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['PRO_FACEBOOK_KEY'], ENV['PRO_FACEBOOK_SECRET']
  end
end  