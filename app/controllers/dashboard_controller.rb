class DashboardController < ApplicationController
  #before_action :authenticate_user!, :except => [:index, :about]

  def index
  end

  def about
  end

  def resume
  end

  def code
  end

  def sandbox
    @tracks = []
  end

  def contact
  end
end
