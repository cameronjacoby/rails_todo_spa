class ToDosController < ApplicationController

  before_action :set_to_do, only: [:show, :update, :destroy]

  # return template without layout
  before_action :render_main_layout_if_format_html

  respond_to :json, :html

  def index
    respond_with (@to_dos = ToDo.all)
  end

  def create
    respond_with ToDo.create(to_do_params)
  end

  def show
    respond_with @to_do
  end

  def update
    respond_with @to_do.update(to_do_params)
  end

  def destroy
    respond_with @to_do.destroy
  end

  private

  def set_to_do
    @to_do = ToDo.find(params[:id])
  end

  def to_do_params
    params.require(:to_do).permit(:task, :description)
  end

  def render_main_layout_if_format_html
    # check the request format
    if request.format.symbol == :html
      render 'layouts/application'
    end
  end

end