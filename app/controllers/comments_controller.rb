class CommentsController < ApplicationController
    def create
        post = Post.find(params[:post_id])
        comment = post.comments.build(comment_params)
        comment.user = current_user
      
        if comment.save
          render json: {
            id: comment.id,
            body: comment.body,
            post_id: post.id,
            commenter: {
              id: comment.user.id,
              name: comment.user.name,
              email: comment.user.email
            }
          }, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

    def update
        comment = Comment.find(params[:id])
      
        if comment.user != current_user
          return render json: { error: "Unauthorized User Acess" }, status: :unauthorized
        end
      
        if comment.update(comment_params)
          render json: { message: "Comment updated succesfully!", comment: comment }
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        comment = Comment.find(params[:id])
      
        if comment.user != current_user
          return render json: { error: "Unauthorized User Acess" }, status: :unauthorized
        end
      
        comment.destroy
        render json: { message: "Comment deleted sucessfully!" }
    end

    private

      def comment_params
        params.require(:comment).permit(:body)
        end
      
end
