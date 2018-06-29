# config valid only for current version of Capistrano
lock "3.10.1"
require 'active_support/core_ext/string'
require_relative "deploy/aws_utils"

set :application, ENV["REPO_URL"].split("/").last.gsub(".git","").underscore.camelize
set :assets_roles, [:app]
set :deploy_ref, ENV["DEPLOY_REF"]
set :deploy_ref_type, ENV["DEPLOY_REF_TYPE"]
set :bundle_binstubs, ->{shared_path.join("bin")}

if fetch(:deploy_ref)
  set :branch, fetch(:deploy_ref)
else
  raise "Please set $DEPLOY_REF"
end

set :rvm_ruby_version, "2.4.1"
set :deploy_to, "/usr/local/rails_apps/#{fetch :application}"
set :settings, YAML.load_file(ENV["SETTING_FILE"] ||"config/deploy/settings.yml")
set :instances, get_ec2_targets unless ENV["LOCAL_DEPLOY"]
set :unicorn_rack_env, ENV["RAILS_ENV"] || "production"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"

# Default value for linked_dirs is []
# NOTE: public/uploads IS USED ONLY FOR THE STAGING ENVIRONMENT
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)

# Default value for default_env is {}
set :default_env, File.read("/home/deploy/.env").split("\n").inject({}){|h,var|
  k_v = var.gsub("export ","").split("=")
  h.merge k_v.first.downcase => k_v.last.gsub("\"", "")
}.symbolize_keys

namespace :deploy do
  desc "create database"
  task :create_database do
    on roles(:db) do |host|
      within "#{release_path}" do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:create"
        end
      end
    end
  end
  before :migrate, :create_database

  desc "link dotenv"
  task :link_dotenv do
    on roles(:app) do
      execute "ln -s /home/deploy/.env #{release_path}/.env"
    end
  end
  before :restart, :link_dotenv

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
    end
  end
  after :publishing, :restart

  desc "update ec2 tags"
  task :update_ec2_tags do
    on roles(:app) do
      within "#{release_path}" do
        branch = fetch(:branch)
        ref_type = fetch(:deploy_ref_type)
        last_commit = ref_type == 'branch' ? `git rev-parse #{branch.split('/')[1]}` : `git rev-list -n 1 #{branch}`
        update_ec2_tags ref_type, branch, last_commit if fetch(:stage) == :production  || !ENV["LOCAL_CARRIERWAVE"]
      end
    end
  end
  after :restart, :update_ec2_tags
end
