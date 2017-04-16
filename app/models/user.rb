class User < ApplicationRecord
  has_one :cart, as: :overall_user
  # Include default users modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


end
