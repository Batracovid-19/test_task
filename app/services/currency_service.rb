class CurrencyService
  def initialize(date)
    @date = date.blank? ? Time.now.utc.strftime('%Y-%m-%d') : date
  end

  def call
    OpenStruct.new('success?' => true, 'errors' => nil, 'response' => JSON.parse(ApiCaller.new.call(url: build_url, http_method: :get)))
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    Rails.logger.fatal build_message
    OpenStruct.new('success?' => false, 'errors' => build_message, 'response' => nil)
  end

  private

  attr_reader :date

  def build_url
    @build_url ||= "http://data.fixer.io/api/#{date}?access_key=#{ENV['FIXER_KEY']}"
  end

  def build_message
    @error_message ||= "Something went wrong while you're reaching out url: #{build_url}"
  end
end
