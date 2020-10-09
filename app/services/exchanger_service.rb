class ExchangerService
  def initialize(params)
    @params = params
  end

  def call
    return error_open_struct(success: false, errors: 'invalid params', response: nil) unless params_present?
    currency_service = CurrencyService.new(params[:date]).call

    if currency_service.success?
      OpenStruct.new('success?' => true, 'errors' => nil, 'response' => cross_course(currency_service).round(2).to_s)
    else
      error_open_struct(success: false, errors: currency_service.errors, response: nil)
    end
  end

  private

  attr_reader :params

  def error_open_struct(success:, errors:, response:)
    OpenStruct.new('success?' => success, 'errors' => errors, 'response' => response)
  end

  def params_present?
    params.present? && !params[:exchange_code_from].blank? && !params[:exchange_code_to].blank? && !params[:amount].blank?
  end

  def cross_course(currency_service)
    BigDecimal(params[:amount]) / BigDecimal(currency_service.response.public_send(params[:exchange_code_from].downcase) / currency_service.response.public_send(params[:exchange_code_to].downcase))
  end
end
