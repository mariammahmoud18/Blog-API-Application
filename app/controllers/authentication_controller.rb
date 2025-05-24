class AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: [:login, :signup]

  # POST /signup
  def signup
    user = User.new(user_params)
    if user.save
      token = encode_token(user_id: user.id)
      render json: { user: user_response(user), token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { user: user_response(user), token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image)
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      image: user.image
    }
  end

  # JWT encoding helper
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

end
