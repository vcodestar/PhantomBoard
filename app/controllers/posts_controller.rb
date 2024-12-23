class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:index, :show, :edit, :new]
  before_action :authorize_user!, only: [:destroy, :edit, :update]

  # GET /posts or /posts.json
  def index
    @posts = Post.includes(:comments).order(created_at: :desc)
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post = Post.find(params[:id])
  
    if @post.user == current_user || current_user.admin?
      @post.destroy!
  
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            # Remove the post from the DOM
            turbo_stream.remove("post-#{@post.id}"),
          
          ]
        end
        format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully deleted." }
      end
    else
      redirect_to posts_path, alert: "You are not authorized to delete this post." and return
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :text, :user_id ])
    end

    def authorize_user!
      unless @post.user == current_user  || current_user.admin?
        redirect_to posts_path, notice: "You can only edit, update, delete your own posts."
      end
    end
end
