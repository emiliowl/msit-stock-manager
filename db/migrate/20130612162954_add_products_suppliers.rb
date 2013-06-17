class AddProductsSuppliers < ActiveRecord::Migration
  def up                                     
    create_table :products_suppliers do |t|
      t.integer :product_id
      t.integer :supplier_id
    end    
    add_index :products_suppliers, :product_id
    add_index :products_suppliers, :supplier_id
  end

  def down                                 
    drop_table :products_suppliers
    remove_index :products_suppliers, :product_id
    remove_index :products_suppliers, :supplier_id
  end  
end
