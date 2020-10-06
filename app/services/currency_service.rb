class CurrencyService
  def initialize(date)
    @date = date.blank? ? Time.now.utc.strftime('%Y-%m-%d') : date
  end

  def call
    OpenStruct.new('success?' => true, 'errors' => nil, 'response' => last_or_pull_and_save)
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    Rails.logger.fatal build_message
    OpenStruct.new('success?' => false, 'errors' => build_message, 'response' => nil)
  end

  private

  attr_reader :date

  def last_or_pull_and_save
    currency = Currency.find_by(date: date)

    unless currency
      request = JSON.parse(ApiCaller.new.call(url: build_url, http_method: :get))
      currency = Currency.create(base: request['base'],
                                 date: request['date'],
                                 usd: request['rates']['USD'],
                                 uah: request['rates']['UAH'],
                                 rub: request['rates']['RUB'],
                                 ron: request['rates']['RON'])
    end

    currency
  end

  def build_url
    @build_url ||= "http://data.fixer.io/api/#{date}?access_key=#{ENV['FIXER_KEY']}"
  end

  def build_message
    @error_message ||= "Something went wrong while you're reaching out url: #{build_url}"
  end
end
