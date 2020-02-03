class StaticPagesController < ApplicationController
  def home
    @session = Session.new
  end

  def usage; end
end
