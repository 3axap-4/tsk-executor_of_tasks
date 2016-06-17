class CartsController < ApplicationController
  include TasksHelper
  include CartItems

  before_action :check_sign_in, only: [:show, :add_item, :delete_item]
	before_action :pickup_cart, only: [:add_item, :show]
  before_action :pickup_item, only: [:delete_item]


  def show
  end

  def create
  end

  def add_item 
    if(params.has_key?(:task_id) && Task.exists?(params[:task_id]) && is_task_belongs_current_user?(params[:task_id]))
      respond_to do |format|
        if(CartItem.exists?(cart_id: @cart.id, task_id: params[:task_id]))
          format.html { redirect_to :back, alert: 'Данная задача уже добавленная в корзину' }
        else
          @cart.cart_items << CartItem.create(cart_id: @cart.id, task_id: params[:task_id])
          if(@cart.save)
            format.html { redirect_to :back, notice: 'Задача успешно добавленная в корзину' }
          else
            format.html { redirect_to :back, alert: 'Возникла ошибка при добавлении в корзину пожалуйста повторите попытку' }
          end
        end
      end
    else
      render_404     
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
    if(params.has_key?(:id))
      @item = CartItem.find_by_id(params[:id])
      if(@item.nil? || !is_cart_item_belongs_current_user?(params[:id]))                               
        render_404 
      end
    end
  end

end
