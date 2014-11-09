class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :image]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    respond_to do |format|
      format.html
      format.csv do
        Item.copy_to "/tmp/items.csv"
        send_file "/tmp/items.csv"
      end
    end
  end

  def import_csv
    Item.delete_all
    if Item.copy_from(params[:file].path)
      redirect_to items_path, :notice => "CSVファイルの読み込みに成功しました"
    else
      redirect_to items_path, :notice => "CSVファイルの読み込みに失敗しました。"
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.image = params[:item][:image].read
    @item.image_content_type = params[:item][:image].content_type

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def image
    send_data(@item.image, type: @item.image_content_type, disposition: :inline)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name)
    end
end
