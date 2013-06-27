class ProductsController < ApplicationController
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
        Cloudinary::Uploader.upload(params[:product][:image], 
                                    :public_id => "product#{@product.id}#{@product.created_at}",
                                    :width => 150, :height => 100, 
                                    :crop => :fill, :format => 'png') if params[:product][:image]
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
        Cloudinary::Uploader.upload(params[:product][:image], 
                                    :public_id => "product#{@product.id}#{@product.created_at}",
                                    :width => 150, :height => 100, 
                                    :crop => :fill, :format => 'png') if params[:product][:image]
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
    @product.destroy

    Cloudinary::Uploader.destroy("product#{@product.id}#{@product.created_at}")

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end
