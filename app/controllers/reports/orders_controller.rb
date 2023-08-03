# frozen_string_literal: true

class Reports::OrdersController < ApplicationController
    before_action :authenticate_user!
    layout 'report'

    def show
    end

  end
  