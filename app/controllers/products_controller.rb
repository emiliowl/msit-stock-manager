class ProductsController < ApplicationController         
  
  before_filter :initialize_image_repository, :only => [:create, :update, :destroy]
  
  def initialize_image_repository
    @repository = Repository::ImageRepository.new
  end
  
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create                
    @product = Product.new(params[:product].reject{|item|item == "image"})
    
    respond_to do |format|
      if @product.save                         
        logger.info "start creation of image: #{Time.now}"
        @repository.save_or_update(@product, params[:product][:image]) if params[:product][:image]
        logger.info "end creation of image: #{Time.now}"
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product].reject{|item|item == "image"}) 
        logger.info "start creation of image: #{Time.now}"
        @repository.save_or_update(@product, params[:product][:image]) if params[:product][:image]   
        logger.info "end creation of image: #{Time.now}"     
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])  
    logger.info "start destroying image: #{Time.now}"     
    @repository.destroy_from_model @product                      
    logger.info "end destroying image: #{Time.now}"     
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end
