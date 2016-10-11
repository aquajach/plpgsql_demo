namespace :db do
  desc 'Generates dummy content for exchanging points to gifts'
  task :reload => :environment do
    db = PG::Connection.new(dbname: 'plsql_orm_dev')
    db.exec(File.read("#{Rails.root}/sql/functions.sql"))
  end
end
