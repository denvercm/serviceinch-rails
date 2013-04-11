class AdminController < ApplicationController


  def category_index
    @users = User.all
  end

end
