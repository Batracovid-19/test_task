# frozen_string_literal: true

class ExchangersController < ApplicationController
  def index
    @response = ExchangerService.new(permitted_params).call

    respond_to do |format|
      format.html { render :index }
      format.json do
        if @response && @response.success?
          render json: { result: @response.response }, status: :ok
        else
          render json: { result: @response.errors }, status: :bad_request
        end
      end
    end
  end

  private

  def permitted_params
    params.permit(:exchange_code_from, :exchange_code_to, :amount, :date)
  end
end
