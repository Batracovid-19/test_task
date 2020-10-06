class ApiCaller
  include Retryable

  def call(url:, http_method:)
    with_retries(
      rescue_class: [Faraday::TimeoutError, Faraday::ConnectionFailed],
      retry_skip_reason: 'getaddrinfo: Name or service not known'
    ) do
      connection.public_send(http_method, url).body
    end
  end

  private

  def connection
    @connection ||= Faraday.new(
      request: { open_timeout: 10, timeout: 30 }
    ) do |faraday|
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter
    end
  end
end
