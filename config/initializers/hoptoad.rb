HoptoadNotifier.configure do |config|
  config.api_key = 'dd6af9551efa4c48d765e9175443d733'
  config.ignore_only  = (HoptoadNotifier::IGNORE_DEFAULT.dup << 'ActionController::UnknownAction')
end
