class Repository::ImageRepository   
  
  def initialize
    @formatting_defaults = {:public_id => nil,
                            :width => 150, :height => 100, 
                            :crop => :fit, :format => 'png'}
  end
  
  # Retrieve an image data with it public_id <not implemented yet>
  def get(public_id)
    raise NotImplementedError
  end
    
  # Use this method to store or update an image in the image repository.
  # The main parameters that you have to inform are the model (must be an ActiveRecord and must be persisted),
  # the file and the public_id (if you dont pass this, the repository will generate one for you).
  # If everything goes ok, return the public_id (given or generated)
  def save_or_update(model, file, public_id=nil, formatting_arguments = {})
    raise ArgumentError, 
      "the model must be and instance of ActiveRecord" unless model.is_a?(ActiveRecord::Base) and
                                                              model.persisted?
    public_id ||= model.class.to_s << model.id.to_s << model.created_at.to_s
    
    formatting_arguments = (@formatting_defaults.merge public_id: public_id).merge formatting_arguments
  
    Cloudinary::Uploader.upload(file, formatting_arguments)
    public_id
  end

  def destroy_from_model(model)
    raise ArgumentError, 
      "the model must be and instance of ActiveRecord" unless model.is_a?(ActiveRecord::Base) and
                                                              model.persisted?
      public_id ||= model.class.to_s << model.id.to_s << model.created_at.to_s
      destroy(public_id)
  end
  
  def destroy(public_id)
      response = Cloudinary::Uploader.destroy(public_id)
      if response["result"] == "ok"
        return true 
      else
        return false
      end
  end
    
end