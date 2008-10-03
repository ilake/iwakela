HoptoadNotifier.configure do |config|
  config.api_key = '9d5282c83ba521438fc796e05e71d40e'
  config.ignore_only  = (HoptoadNotifier::IGNORE_DEFAULT.dup << 'ActionController::UnknownAction')
end
