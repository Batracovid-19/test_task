namespace :rates do
  task :populate => :environment do
    currency = CurrencyService.new(Time.now.utc.strftime('%Y-%m-%d')).call
  end
end
