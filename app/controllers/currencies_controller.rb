# frozen_string_literal: true

class CurrenciesController < ApplicationController
  def index
    currencies = Currency.where(created_at: params[:date_from]..params[:date_to])

    render json: { result: currencies }, status: :ok
  end

  private

  def permitted_params
    params.permit(:date_from, :date_to)
  end
end
