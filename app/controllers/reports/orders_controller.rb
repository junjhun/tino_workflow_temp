# frozen_string_literal: true

class Reports::OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: %i[show]
    before_action :set_user, only: %i[show]
    layout 'report'

    def show
      @user = User.find(params[:id])
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def set_user
      @user = current_user
    end
  end
  