class ItemsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]

  def index
  end

  def show
    @item = Item.find(params[:id])
    @comment = Comment.new
    @comments = @item.comments.includes(:user)
  end

  def new
    @item = Item.new
    @item.item_images.build
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      redirect_to new_item_path
    end
  end

  def search_child
    respond_to do |format|
      format.html
      format.json do
        @childrens = Category.find(params[:parent_id]).children
      end
    end
  end

  def search_grandchild
    respond_to do |format|
      format.html
      format.json do
        @grandchildrens = Category.find(params[:child_id]).children
      end
    end
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def done
  end

  def destroy
    item = Item.find(params[:id])
    if item.destroy
      redirect_to root_path, notice: '削除しました'
    else
      render :show
    end
  end

  private
  def item_params
    params.require(:item).permit(
      :name, :detail, :price, :category_id, :size_id, :shipping_method_id, :condition_id, :shipping_days_id, :fee_burden_id, :prefecture_id, :brand_id, [item_images_attributes: [:url]]
      ).merge(user_id: current_user.id, seller: current_user.id, order_status: "出品中")
  end
  
end
