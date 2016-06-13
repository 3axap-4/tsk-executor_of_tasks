class CartsController < ApplicationController

	before_action :pickup_cart, only: [:add_item, :show]
  before_action :pickup_item, only: [:delete_item]


  def show
  end

  def create
  end

  def add_item 
    if(params.has_key?(:task_id))
      respond_to do |format|
        if(CartItem.exists?(cart_id: @cart.id, task_id: params[:task_id]))
          format.html { redirect_to :back, alert: 'Данная задача уже добавленная в корзину' }
        else
          @cart.cart_items << CartItem.create(cart_id: @cart.id, task_id: params[:task_id])
          if(@cart.save)
            format.html { redirect_to :back, notice: 'Задача успешно добавленная в корзину' }
          end
        end
      end     
    end
  end

  def delete_item
    @item.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Позиция успешно удалена' }
      format.json { head :no_content }
    end
  end

  private 

  def pickup_cart
  	if(!current_user.nil? && current_user.cart.nil?)
      @cart = Cart.create(user: current_user)
    else
      @cart = current_user.cart
    end
  end

  def pickup_item 
    @item = CartItem.find(params[:id])
  end

end
