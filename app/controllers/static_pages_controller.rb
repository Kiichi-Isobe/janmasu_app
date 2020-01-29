class StaticPagesController < ApplicationController
  def home
    @session = Session.new
  end
end
