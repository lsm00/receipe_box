class RecipesController < ApplicationController
  #before_action :authenticate_user!
  before_action :find_recipe, only: [:show, :edit, :update, :destroy]


  def index
    @recipe = Recipe.all.order("created_at DESC")
  end

  def new
    @recipe = current_user.recipes.build
  end

  def show
  end

  def create
    @recipe = current_user.recipes.build (recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Success creating your Recipe!"
    else
      render 'new'
    end
  end

  def edit
    if current_user == @recipe.user   #checks if current user is owner of the pin
      @recipe = Recipe.find(params[:id])
    else
      flash[:danger] = "Wrong user! You are not allowed to do this!"
      redirect_to @recipe
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Update successful!"
    else
      render 'edit'
    end
  end

  def destroy
    if current_user == @recipe.user
      @recipe.destroy
      redirect_to root_path
    else
      flash[:danger] = "Wrong user! You are not allowed to do this!"
      redirect_to @recipe
    end
  end


  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :image)
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])
  end

end
