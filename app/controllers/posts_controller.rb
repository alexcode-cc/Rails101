class PostsController < ApplicationController
  #before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_board

  # GET /posts or /posts.json
  def index
    #@posts = Post.all
    redirect_to board_path(@board)
  end

  # GET /posts/1 or /posts/1.json
  def show
    set_post
  end

  # GET /posts/new
  def new
    #@post = Post.new
    @post = @board.posts.build
  end

  # GET /posts/1/edit
  def edit
    set_post
  end

  # POST /posts or /posts.json
  def create
    #@post = Post.new(post_params)
    @post = @board.posts.build(post_params)

    respond_to do |format|
      if @post.save
        #format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.html { redirect_to board_post_path(@board,@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    set_post
    respond_to do |format|
      if @post.update(post_params)
        #format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.html { redirect_to board_post_path(@board,@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    set_post
    @post.destroy

    respond_to do |format|
      #format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.html { redirect_to board_posts_path(@board,@post), notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:board_id])
    end

    def set_post
      #@post = Post.find(params[:id])
      @post = @board.posts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
