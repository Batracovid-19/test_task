class ExchangerService
  def initialize(params)
    @params = params
  end

  def call(currency = CurrencyService.new(params[:date]))
    return unless params_present?

    currency = currency.call

    if currency.success?
      OpenStruct.new('success?' => true, 'errors' => nil, 'response' => cross_course(currency).round(2).to_s)
    else
      OpenStruct.new('success?' => false, 'errors' => currency.errors, 'response' => nil)
    end
  end

  private

  attr_reader :params

  def params_present?
    params.present? && !params[:exchange_code_from].blank? && !params[:exchange_code_to].blank? && !params[:amount].blank?
  end

  def cross_course(currency)
    params[:amount].to_d / (currency.response['rates'][params[:exchange_code_from].upcase] / currency.response['rates'][params[:exchange_code_to].upcase]).to_d
  end
end
