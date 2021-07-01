class PostsController < ApplicationController

    def index
      @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all

        @posts = Post.all
        if params[:search] == nil
          @posts= Post.all.page(params[:page]).per(3)  
        elsif params[:search] == ''
          @posts= Post.all.page(params[:page]).per(3)
        else
          #部分検索
          @posts = Post.where("category LIKE ? ",'%' + params[:search] + '%').page(params[:page]).per(3)
        end

        if params[:search].present?
          posts = Post.posts_serach(params[:search])
        elsif params[:tag_id].present?
          @tag = Tag.find(params[:tag_id])
          posts = @tag.posts.order(created_at: :desc)
        else
          posts = Post.all.order(created_at: :desc)
        end
        @tag_lists = Tag.all
        
        
      

    end

   

    def new
        @posts = Post.new
    end

    def create
      #post = Post.new(post_params)
      #post.user_id = current_user.id
   
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tag_ids].split(',')
    if @post.save
       @post.save_tags(tag_list)
       flash[:success] = '投稿しました!'
       redirect_to root_url
    else
      render 'new'
    end

    @post = Post.new(post_params)
    tag_list = params[:post][:tag_name].split(nil)
    @post.image.attach(params[:post][:image])
    @post.user_id = current_user.id
    if @post.save
       @post.save_posts(tag_list)
      redirect_to post_path
    else
      flash.now[:alert] = '投稿に失敗しました'
      render 'new'
    end
  end


      def show
        @post = Post.find(params[:id])
        @comments = @post.comments
        @comment = Comment.new
      end

      def edit
        @post = Post.find(params[:id])
        @tag_list =@post.tags.pluck(:name).join(",")
        
      end
    
      def update
        @post = Post.find(params[:id])
        tag_list = params[:post][:tag_ids].split(',')
        if @post.update(post_params)
           @post.save_tags(tag_list)
           flash[:success] = '投稿を編集しました‼'
           redirect_to @post
        else
        render 'edit'
        end
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        redirect_to action: :index
      end

      

      private
      def post_params
        params.require(:post).permit(:title, :about, :category, :url, :image, :overall)
      end

end
