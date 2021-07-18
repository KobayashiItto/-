class PostsController < ApplicationController

    def index
      @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all

        @posts = Post.all
        if params[:search] == nil
          @posts= Post.all.page(params[:page]).per(10)  
        elsif params[:search] == ''
          @posts= Post.all.page(params[:page]).per(10)
        else
          #部分検索
          @posts = Post.where("category LIKE ? ",'%' + params[:search] + '%').page(params[:page]).per(3)
        end
        @tag_list = Tag.all
    end

    

  

    def new
        @posts = Post.new
        
    end

    def create
      @post = Post.new(post_params)
      #@post.user_id = current_user.id
  
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tag_ids].split(',')
    if @post.save
      @post.save_tags(tag_list)
      flash[:success] = '投稿しました!'
      redirect_to root_url
    else
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

      def search
        @tag_list = Tag.all  #こっちの投稿一覧表示ページでも全てのタグを表示するために、タグを全取得
        @tag = Tag.find(params[:tag_id])  #クリックしたタグを取得
        @posts = @tag.posts.all           #クリックしたタグに紐付けられた投稿を全て表示
      end

      

      private
      def post_params
        params.require(:post).permit(:title, :about, :category, :url, :image, :overall)
      end

      
end
