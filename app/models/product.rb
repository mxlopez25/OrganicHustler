class Product < ApplicationRecord
  has_many :sizes
  has_many :logos
  has_many :colors
  has_many :presets
  has_many :emblems
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :styles
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :brands
  has_one :product_image
  has_many :position_emblem_admins
  has_many :history_counts, as: :owner

  def taxes
    TaxBand.find self.tax_band_id
  end

  def self.find_by_category(title)
    Category.find_by_title(title).products
  end

  def self.get_all_images(id)
    colors = Color.where(product_id: id)
    images = []
    colors.each do |color|
      color.product_images.each do |pictures|
        images.push [pictures.picture("thumb_#{@browser}"), pictures.picture]
      end
    end
    images
  end

  def self.get_all_images_colors(id)
    colors = Color.where(product_id: id)
    colors_array = []
    colors.each do |color|
      color_obj = {color: color, pictures: []}
      color.product_images.each do |pictures|
        color_obj[:pictures].push({data: pictures, url: [pictures.picture("thumb_#{@browser}"), pictures.picture]})
      end
      colors_array.push color_obj
    end
    colors_array
  end

  def self.get_all_sizes(id)
    sizes = (Product.find id).sizes
    sizes
  end

  def self.get_by_attributes(id, sku, title, amount, category, page)

    sql = "SELECT SQL_CALC_FOUND_ROWS DISTINCT products.* FROM products " +
        "#{category.blank? ? '' : 'INNER JOIN categories_products ON products.id = categories_products.product_id'} " +
        "#{
        if id.blank? && sku.blank? && title.blank? && amount.blank? && category.blank?
          ''
        else
          "WHERE " +
              "#{id.blank? ? '' : 'products.id = ' + id + ' AND'} " +
              "#{sku.blank? ? '' : 'sku = ' + sku + ' AND'} " +
              "#{title.blank? ? '' : 'products.title LIKE \'%'+ title +'%\'' + ' AND'} " +
              "#{category.blank? ? '' : 'category_id = ' + category + ' AND'} " +
              "#{amount.blank? ? '' : 'price <= ' + amount + ' AND'} "
        end
        }  LIMIT #{10 * (page.to_i - 1)}, 10"

    sql = sql.reverse.sub('AND'.reverse, ''.reverse).reverse
    p sql

    n_rows = 'SELECT FOUND_ROWS();'

    results = ActiveRecord::Base.connection.execute(sql)
    total = ActiveRecord::Base.connection.execute(n_rows).each(:as => :hash)[0]
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    [products, total]
  end

  def simple_info
    {
      id: id,
      product_image_id: colors.try(:first).try(:product_images).try(:first).picture("medium_#{browser}"),
      title: title
    }
  end

end
