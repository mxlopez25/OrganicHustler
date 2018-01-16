class TaxBandsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def new

  end

  def edit
    @taxes = TaxBand.find(params['id'])
  end

  def update
    params['taxes'].permit!
    TaxBand.find(params['id']).update! params['taxes']
  end

  def destroy
    ta = TaxBand.find(params['id'])
    ta.active = !ta.active
    ta.save!
  end

  def create
    params['taxes'].permit!
    TaxBand.create! params['taxes']
  end

  def show
    titulo = params['titulo'].blank? ? '' : params['titulo']
    amount = params['amount'].blank? ? 99999999999 : params['amount']
    description = params['description'].blank? ? '' : params['description']

    sql = "SELECT DISTINCT tax_bands.* FROM tax_bands WHERE amount <= #{amount} AND titulo LIKE '%#{titulo}%' AND description LIKE '%#{description}%'"

    results = ActiveRecord::Base.connection.execute(sql)
    products = []
    results.each(:as => :hash) do |row|
      products << row.with_indifferent_access
    end

    render json: products.to_json
  end

end
