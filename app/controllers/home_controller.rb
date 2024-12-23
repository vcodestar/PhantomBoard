class HomeController < ApplicationController

  before_action :authenticate_user!, only: [:index]

  def index
  end

  def about
  end
end
