class GiftsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def show

    rate = params['rate'].blank? ? 100.0 : params['rate']
    code = params['code'].blank? ? '' : params['code']
    limit = params['limit'].blank? ? 99999999999 : params['limit']
    time = params['time'].blank? ? Time.now.to_datetime.next_year(1000).to_time.to_s(:db) : params['time']
    used = !(params['used'].eql? 'false')

    sql = "SELECT DISTINCT gifts.* FROM gifts WHERE rate <= #{rate} AND code LIKE '%#{code}%' AND limit_usage <= #{limit} AND time_available <= '#{time}' AND used = #{used}"
    if params['used'].eql? 'not'
      sql = "SELECT DISTINCT gifts.* FROM gifts WHERE rate <= #{rate} AND code LIKE '%#{code}%' AND limit_usage <= #{limit} AND time_available <= '#{time}'"
    end
    p sql

    results = ActiveRecord::Base.connection.execute(sql)
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    render json: products.to_json
  end

  def new

  end

  def edit
    @promo = Gift.find(params['id'])
  end

  def create

    params['promo'].permit!
    Gift.create! params['promo']

  end

  def update
    params['promo'].permit!
    Gift.find(params['id']).update! params['promo']
  end

  def destroy
    Gift.find(params['id']).update! used: true
  end
end
