class DashboardsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @gears = current_user.gears
  end

end

