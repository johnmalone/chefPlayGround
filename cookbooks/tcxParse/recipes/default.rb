#
# Cookbook Name:: tcxParse
# Recipe:: default
#
# Copyright 2014, TCX Parse
#
# All rights reserved - Do Not Redistribute
#

tcxHome = "#{node['tcxparse']['homedir']}"

mysql_root = "#{node['mysql']['server_root_password']}"
bash "create_homestead_db" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  echo "create database if not exists #{node['tcxparse']['database']}"  | mysql -u root -p#{mysql_root}
  echo "GRANT ALL PRIVILEGES ON #{node['tcxparse']['database']}.* TO #{node['tcxparse']['databaseuser']}@localhost IDENTIFIED BY '#{node['tcxparse']['databasepassword']}'"   | mysql -u root -p#{mysql_root}
EOH
end

git "#{tcxHome}" do
  repository "git://github.com/johnmalone/tcxparse.git"
  revision "master"
  action :sync
end

execute "permsOnStorage" do
 command "chown -R www-data.www-data #{tcxHome}/app/storage ; chmod -R 777 #{tcxHome}/app/storage"
 user "root"
 action :run
end


tcxDatabaseHost = "#{node['tcxparse']['databasehost']}"
tcxDatabase= "#{node['tcxparse']['database']}"
tcxDatabaseUser = "#{node['tcxparse']['databaseuser']}"
tcxDatabasePassword = "#{node['tcxparse']['databasepassword']}"

template "#{tcxHome}/app/config/database.php" do
  source "database.php.erb"
  mode "0644"
  variables(
    :tcxDatabaseHost => tcxDatabaseHost,
    :tcxDatabase => tcxDatabase,
    :tcxDatabaseUser => tcxDatabaseUser,
    :tcxDatabasePassword => tcxDatabasePassword
  )
end

bash "composer_update" do
  user "root"
  cwd "#{tcxHome}"
  code <<-EOH
  composer update
EOH
end

bash "migrate_dbs" do
  user "root"
  cwd "#{tcxHome}" 
  code <<-EOH
  php artisan migrate --force
EOH
end

include_recipe "supervisord"

supervisord_program "runQueue" do
  command "#{tcxHome}/app/cli/runQueue.bash"
end

