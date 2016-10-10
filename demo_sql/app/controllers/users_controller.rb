class UsersController < ApplicationController
  before_action :init_db

  def index
    render json: {data: query('all_users()')}
  end

  def show
    render json: {data: query('get_user($1)', [params[:login]])}
  end

  def create
    # @user = User.new(user_params)
    render json: {data:
      query('create_user($1, $2, $3)', [user_params[:name], user_params[:email], user_params[:phone]])
    }
      # render 'show'
    # else
    #   @errors = @user.errors
    #   render 'error'
    # end
  end

  def query(sql, params = [])
    JSON.parse @db.exec_params("select data from #{sql}", params).first['data']
  end

  private
  def init_db
    @db = PG::Connection.new(dbname: 'plsql_orm_dev')
  end

  def user_params
    params.require(:user).permit(:email, :phone, :name)
  end
end
