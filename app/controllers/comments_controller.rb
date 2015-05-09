class CommentsController < ApplicationController
  def create
    @character = Character.find(params["character_id"])
    @comment = Comment.build(text: params["comment"]["text"], character: @character)
    if @comment.save
      render json: @comment
    end
  end
end