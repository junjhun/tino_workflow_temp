# frozen_string_literal: true

class Reports::OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: %i[show]
    layout 'report'

    def show
      @report = request.query_parameters&.first&.second
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
  end
  