class UsersController < ApplicationController
  before_action :init_db

  def index
    query_and_render('all_users()')
  end

  def show
    query_and_render('get_user($1)', [params[:login]])
  end

  def create
    query_and_render('create_user($1, $2, $3)',
                     [user_params[:name], user_params[:email], user_params[:phone]])
  end

  def query_and_render(sql, params = [])
    data = begin
      result = @db.exec_params("select data from #{sql}", params).first['data']
      JSON.parse result if result
    rescue PG::RaiseException => e
      render json: {message: e.message, status: 422} and return
    end
    render json: {data: data}
  end

  private
  def init_db
    @db = PG::Connection.new(dbname: 'plsql_orm_dev')
  end

  def user_params
    params.require(:user).permit(:email, :phone, :name)
  end
end
