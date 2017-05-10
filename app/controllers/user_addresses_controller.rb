class UserAddressesController < ApplicationController

  def update
    current_user.user_address.update(address_params)
  end

  def address_params
    params.require(:user_address).permit(:street_address, :city, :state, :zip_code, :area, :number)
  end

end