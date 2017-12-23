class CategoriesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def new

  end

  def edit
    @categories = Category.find(params['id'])
  end

  def update
    params['categories'].permit!
    Category.find(params['id']).update! params['categories']
  end

  def destroy
    Category.find(params['id']).destroy!
  end

  def create
    params['categories'].permit!
    Category.create! params['categories']
  end

  def show
    title = params['title'].blank? ? '' : params['title']
    sql = "SELECT DISTINCT categories.* FROM categories WHERE title LIKE '%#{title}%'"

    results = ActiveRecord::Base.connection.execute(sql)
    categories = []
    results.each(:as => :hash) do |row|
      categories << row.with_indifferent_access
    end

    render json: categories.to_json
  end

end
