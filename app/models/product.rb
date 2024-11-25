class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 1 }
  validates :description, length: { maximum: 5000 }

  def is_discounted?
    price <= 10
  end

  def tax
    price * 0.09
  end

  def supplier
    Supplier.find_by(id: supplier_id)
  end

  def total
    price + tax
  end

  belongs_to :supplier
  has_many :images
  # def images
  #   Image.where(product_id: id)
  # end
  def primary_image_url
    if images.length > 0
      images[0].url
    else
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
    end
  end
end
