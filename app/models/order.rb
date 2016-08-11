class Order < ActiveRecord::Base
  belongs_to :user
  before_validation :set_total!

  validates :total, presence: true,
                      numericality: { greater_than_or_equal_to: 0 }

  validates :title, :user_id, presence: true
  has_many :placements
  has_many :products, through: :placements
  	def show
	  respond_with current_user.orders.find(params[:id])
	end
	def create
  order = current_user.orders.build(order_params)

  if order.save
    render json: order, status: 201, location: [:api, current_user, order]
  else
    render json: { errors: order.errors }, status: 422
  end
end

private

def order_params
  params.require(:order).permit(:product_ids => [])
end
end