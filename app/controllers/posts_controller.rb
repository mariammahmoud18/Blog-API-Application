class PostsController < ApplicationController

    def index
        @posts = Post.includes(:user, :tags, comments: :user).all
      
        render json: @posts.map { |post|
          {
            id: post.id,
            title: post.title,
            body: post.body,
            created_at: post.created_at,
            author: {
              name: post.user.name,
              email: post.user.email
            },
            tags: post.tags.map { |tag| { name: tag.name } },
            comments: post.comments.map { |comment|
              {
                id: comment.id,
                body: comment.body,
                commenter: {
                  name: comment.user.name,
                  email: comment.user.email
                }
              }
            }
          }
        }
      end

      def show
        post = Post.includes(:user, :tags, comments: :user).find(params[:id])
      
        render json: {
          id: post.id,
          title: post.title,
          body: post.body,
          created_at: post.created_at,
          author: {
            name: post.user.name,
            email: post.user.email
          },
          tags: post.tags.map { |tag| { name: tag.name } },
          comments: post.comments.map { |comment|
            {
              id: comment.id,
              body: comment.body,
              commenter: {
                name: comment.user.name,
                email: comment.user.email
              }
            }
          }
        }
      end



      def create
        post = current_user.posts.build(title: post_params[:title], body: post_params[:body])
      
        tag_names = params[:tags]
      
        if tag_names.blank? || !tag_names.is_a?(Array) || tag_names.empty?
          return render json: { error: "At least one tag is required" }, status: :unprocessable_entity
        end
      
        tags = tag_names.map do |tag_name|
          Tag.find_or_create_by(name: tag_name.downcase.strip)
        end
      
        post.tags = tags
      
        if post.save
          render json: {
            id: post.id,
            title: post.title,
            body: post.body,
            tags: post.tags.map(&:name),
            author: {
              id: post.user.id,
              name: post.user.name,
              email: post.user.email
            }
          }, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end
    #   def create
    #     @post = Post.new(post_params)
    #     @post.user = current_user
      
    #     if @post.save
    #       tag_ids = params[:tag_ids] || []
    #       if tag_ids.empty?
    #         render json: { error: "Post must have at least one tag" }, status: :unprocessable_entity
    #         @post.destroy
    #       else
    #         @post.tag_ids = tag_ids
    #         render json: @post, status: :created
    #       end
    #     else
    #       render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    #     end
    #   end

    def update
        @post = Post.find(params[:id])
        if @post.user != current_user
          render json: { error: "Unauthorized User Acess" }, status: :unauthorized
          return
        end
      
        if @post.update(post_params)
          @post.tag_ids = params[:tag_ids] if params[:tag_ids]
          render json: @post
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end


    # PATCH /posts/:id/update_tags
def update_tags
    post = Post.find(params[:id])
  
    # Make sure only the post's owner can update tags
    if post.user != current_user
      return render json: { error: "Unauthorized User Access" }, status: :unauthorized
    end
  
    # Expect an array of tag IDs from the request
    tag_ids = params[:tag_ids]
  
    if tag_ids.blank? || tag_ids.empty?
      return render json: { error: "A post must have at least one tag." }, status: :unprocessable_entity
    end
  
    # Assign the new tags to the post
    post.tag_ids = tag_ids
  
    render json: {
      message: "Tags updated successfully",
      tags: post.tags.map { |tag| { id: tag.id, name: tag.name } }
    }
  end
    
  
def update_tags
    post = Post.find(params[:id])
  
    if post.user != current_user
      return render json: { error: "Unauthorized User Access" }, status: :unauthorized
    end
  
    tag_ids = params[:tag_ids]
  
    if tag_ids.blank? || tag_ids.empty?
      return render json: { error: "A post must have at least one tag." }, status: :unprocessable_entity
    end
  
    post.tag_ids = tag_ids
  
    render json: {
      message: "Tags updated successfully",
      tags: post.tags.map { |tag| { id: tag.id, name: tag.name } }
    }
  end
  
      def destroy
        @post = Post.find(params[:id])
        if @post.user != current_user
          render json: { error: "Unauthorized User Access" }, status: :unauthorized
          return
        end
      
        @post.destroy
        render json: { message: "Post deleted Succesfully!" }
      end

      private

      def post_params
        params.permit(:title, :body, tags: [])
      end
      

      
end
