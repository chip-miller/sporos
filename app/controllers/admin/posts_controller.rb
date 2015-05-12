class Admin::PostsController < Admin::BaseController
  include PostsHelper
  
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # rescue_from ::LinkThumbnailer::BadUriFormat,      with: :bad_request
  # rescue_from ::ActionController::ParameterMissing, with: :bad_request
  # rescue_from ::NameError,                          with: :bad_request

  respond_to :html

  def index
    my_recently_approved_posts = current_user.posts.where(['published_at > ?', 2.days.ago]).order(published_at: :desc).limit(5)
    i_should_approve           = current_user.approval_requests.action_required.includes(:post).paginated(params[:page]).per(10).map(&:post)
    i_wrote_this               = current_user.posts.paginated(params[:page]).per(10)
    my_pending_posts           = i_wrote_this.pending.paginated(params[:page]).per(10)
    my_rejected_posts          = i_wrote_this.rejected.paginated(params[:page]).per(10)
      
    @grouped_posts = {
      "Recently Published" => my_recently_approved_posts,
      "Approval Required"  => i_should_approve,
      "Rejected Posts"     => my_rejected_posts,
      "Pending Posts"      => my_pending_posts,
    }
    
    # inject counts here
    @grouped_posts.each do |grouped, posts|
      these_approval_requests = ApprovalRequest.where(post:posts, user:current_user).includes(:comment_threads).all
      @grouped_posts[grouped] = posts.map do |post|
        this_posts_request = these_approval_requests.find {|request| request.post_id == post.id}
        if this_posts_request
          post.unread_comment_count = this_posts_request.comment_threads.select {|comment| comment.created_at > comment.commentable.last_vistited_at }.length #.unread_comments.count       
        else
          post.unread_comment_count = 0
        end
        post
      end.sort_by(&:unread_comment_count).reverse
    end
    
    
    respond_with(@grouped_posts)
  end

  def show
    @comments = @post.comment_threads
    @current_users_approval_request = ApprovalRequest.find_by( user:current_user, post:@post )
    
    respond_with(@post)
  end

  def new
    @type = params[:post_type]
    @post = "posts/#{@type}".classify.constantize.new
    set_possible_poster_images
    
    respond_with(@post)
  end

  def edit
    set_possible_poster_images
  end

  def create
    post_class = post_params[:type].constantize
    @post = post_class.new(post_params.merge(author:current_user) )
    @post.save
    
    set_possible_poster_images
    respond_with(@post.becomes(Post))
  end

  def update
    keep_poster_alternatives
    @post.update(post_params)
    
    set_possible_poster_images
    respond_with(@post.becomes(Post))
  end

  def destroy
    @post.destroy
    respond_with(@post.becomes(Post))
  end

  # GET /admin/posts/link_preview?url=<URL>
  def link_preview
    @preview = LinkThumbnailer.generate params[:url], image_stats:'true'
    render json: @preview
  end
  
  private
    def set_post
      @post ||= current_user.posts.includes(:ministry).find_by(public_id:params[:id])
      @post ||= current_user.approval_requests.action_required.includes(:post).map(&:post).find {|post| post.public_id == params[:id]}
    end
    
    def set_type
      @type ||= post_type_of( @post )
    end
        
    def post_params
      @post_params ||= params.require(:post).permit(:type, :ministry_id, :title, :description, :poster, :poster_remote_url, :expired_at, display_options:[:url, :event_date, :event_time, poster_alternatives:[]])
    end
    
    def posts_url
      admin_posts_url
    end

    def post_url(post)
      admin_post_url(post)
    end
    
    def set_possible_poster_images
      if set_type == 'link'
        @possible_poster_images ||= ([@post.poster.url] | (@post.poster_alternatives || []) ).compact
      end
    end
    
    def keep_poster_alternatives
      if set_type == 'link' && post_params[:display_options][:poster_alternatives].nil?
        post_params[:display_options][:poster_alternatives] = @post.poster_alternatives
      end
    end
end
