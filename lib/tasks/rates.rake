namespace :rates do
  task :populate => :environment do
    currency = CurrencyService.new(Time.now.utc.strftime('%Y-%m-%d')).call
    Currency.create!(currencies: currency.result['rates'].to_json) if currency.success?
  end
end
