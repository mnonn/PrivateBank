class ArticlesController < ApplicationController
  def index
    @articles = Article.all.page(params[:page])
   end
    
  def show
    @article = Article.find(params[:id])
  end  
  
  def new
    @article = current_user.articles.build
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = current_user.articles.build(article_params)
    
    if @article.save
      redirect_to root_path
    else
      render 'new'
    end 
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to root_path
    else 
      render 'edit'
    end
  end
  
  def destroy
  	@article = Article.find(params[:id])
  	@article.destroy
  	
  	redirect_to root_path
  end

  private
    def article_params
      params.require(:article).permit(:title,:author,:text)
    end
end
