require 'test_helper'

class ImageRepositoryTest < ActiveSupport::TestCase   
    
  def setup
    @repo = Repository::ImageRepository.new
    @pid = nil
  end
  
  def teardown
    if @pid
      @repo.destroy(@pid)
    end
  end
                
  # SAVE_OR_UPDATE TESTS
  test "On save_or_update the model must be an ActiveRecord" do  
    assert_raise(ArgumentError) {
      @repo.save_or_update("Product", get_file, "test1")
    }
  end
  
  test "On save_or_update the model must be persisted" do
    assert_raise(ArgumentError) {
      @repo.save_or_update(Product.new, get_file,"test1")
    }
  end
  
  test "On save_or_update succesfully should return the informed public_id" do
    @pid = @repo.save_or_update(Product.create!(:name => "P1"), get_file,"test1")
    assert @pid == "test1"
  end
     
  test "On save_or_update succesfully should return the generated public_id" do
    product = Product.create!(:name => "P2")
    @pid = @repo.save_or_update(product, get_file)
    assert @pid == product.class.to_s << product.id.to_s << product.created_at.to_s
  end
  
  # DESTROYING TESTS
  test "On destroy existing image should return true" do
    @repo.save_or_update(Product.create!(:name => "P1"), get_file, "test1")
    result = @repo.destroy("test1")
    assert result
  end                             
               
  test "On destroy not existing image should return false" do
    result = @repo.destroy("not_existing")
    refute result
  end

  test "On destroy_from_model the model must be an ActiveRecord" do      
    assert_raise(ArgumentError) {
      @repo.destroy_from_model("product") 
    }
  end
  
  test "On destroy_from_model the model must be persisted" do
    assert_raise(ArgumentError) {
      @repo.destroy_from_model(Product.new) 
    }
  end

  test "On destroy_from_model with existing parameter should return true" do
    product = Product.create!(:name => "P1")
    @repo.save_or_update(product, get_file)
    result = @repo.destroy_from_model(product)
    assert result
  end

  test "On destroy_from_model with not existing parameter should return false" do
    product = Product.create!(:name => "P1")
    result = @repo.destroy_from_model(product)
    refute result
  end

  # RETRIEVING TESTS
  test "On get should raise error" do
    assert_raise(NotImplementedError) {
      @repo.get("test1")
    }
  end
  
end