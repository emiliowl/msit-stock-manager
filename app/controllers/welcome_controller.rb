class WelcomeController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end     
end