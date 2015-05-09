class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  def index
    @characters = Character.all
  end

  def show
  end

  def new
    @character = Character.new
  end

  def edit
  end

  def create
    @character = Character.new(character_params)

    if @character.save
      redirect_to @character, notice: "#{@character.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @character.update(character_params)
      redirect_to @character, notice: "#{@character.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @character.destroy
    redirect_to characters_url, notice: "#{@character.name} was successfully destroyed."
  end

  private
    def set_character
      @character = Character.find(params[:id])
    end

    def character_params
      params.require(:character).permit(:name, :image_url)
    end
end
