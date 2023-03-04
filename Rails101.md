# Install Ubuntu 20.04 LTS
Install Ubuntu Server 20.04 LTS

## Install openssh-server
enable openssh server

```sh
sudo apt install openssh-server
```

## Install ssh Key
create ssh key for user

```sh
ssh-keygen -t rsa -C user@ubuntu
```

## Enabld authorized_keys
copy authorized user's key for enable public key authorize

```sh
cd ~/.ssh
cat /tmp/key.pub >> authorized_keys
chmod 600 authorized_keys
```

## Setup aliases
setup useful aliases

```sh
vim ~/.bash_aliases
```

```sh
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias vin='vim +NERDTree'
```

```sh
source ~/.bash_aliases
```

## Update Ubuntu

aka `sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y`

```sh
update
```

## Install Packages
install packages for development

```sh
sudo apt install git git-flow vim curl wget gpg w3m -y
```

# Setup Ubuntu
setup Ubuntu development environment

## Config Git
config git's global settings

```sh
git config --global user.name user
git config --global user.email user.mail
git config --global core.editor vim
git config --global ui.color true
git config --global init.defaultBranch main
```

## Setup Vim
setup Vim and plugins

```sh
git clone git@github.com:alexcode-cc/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone git@github.com:lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8
wget https://raw.githubusercontent.com/alexcode-cc/myconfig/main/.vimrc ~/.vimrc
vim +PluginInstall!
```

## Setup RVM
setup RVM for ruby management

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
```


## Setup gemrc for disable install documents
```sh
vim ~/.gemrc
```

```yml
gem: --no-ri --no-rdoc --no-document
```

## Install Ruby 2.7.2
```sh
rvm install 2.7.2 --disable-install-document
gem update --system
ruby -v
```

`rb 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]`

```sh
gem -v
```

`3.4.7`

## Install Node 16.9.1

```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs
sudo npm install -g npm
sudo npm install -g yarn
node -v
```

`v16.19.1`

```sh
npm -v
```

`9.5.1`

```sh
yarn -v
```

`1.22.19`

## Create RVM Gemset 

```sh
rvm use 2.7.2@rails517 --create --default --ruby-version
```

## Install Rails 5.1.7

```sh
gem install rails -v 5.1.7
```

## Setup UFW

```sh
sudo ufw allow from 192.168.0.0/24
sudo ufw enable
```

# Setup Rails101

## Create New Project

```sh
rails new rails101
cp .ruby-gemset rails101/.
cp .ruby-version rails101/.
cd rails101
bundle install
echo rails server -b 0.0.0.0 $@ >> run.sh
chmod u+x run.sh
./run.sh
```

## Init Git

```sh
git add .
git commit -m "Initial commit"
git branch -m master main && git symbolic-ref HEAD refs/heads/main 
git flow init
```

## Add About page

```sh
rails generate controller pages
vim app/controllers/pages_controller.rb
```

```rb
require 'socket'
class PagesController < ApplicationController
  def about
    #@rails = Rails.version
    #@ruby = RUBY_VERSION
    #@env = Rails.env
    @host = Socket.gethostname
    @ip = Socket.ip_address_list.find { |allip| allip.ipv4? && !allip.ipv4_loopback? }.ip_address
    @remote_ip = request.remote_ip
    #@time = Time.current
  end 
end 
```

```sh
vim app/views/pages/about.html.erb
```

```rb
<p id="notice"><%= notice %>
</p>                                                                                       
<h1><%= Rails.application.class.parent_name %></h1> 
<hr>
<table>
  <thead> 
    <tr>
      <th></th>
      <th></th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>Rails Version</td>
      <td><%= Rails.version %></td>
    </tr>
    <tr>
      <td>Ruby Version</td>
      <td><%= RUBY_VERSION %></td>
    </tr>
    <tr>
      <td>Rails Environment</td>
      <td><%= Rails.env %></td>
    </tr>
    <tr>
      <td>Host</td>
      <td><%= @host %></td>
    </tr>
    <tr>
      <td>Host IP</td>
      <td><%= @ip %></td>
    </tr>
    <tr>
      <td>Remote IP</td>
      <td><%= @remote_ip %></td>
    </tr>
    <tr>
      <td>Current Time</td>
      <td><%= Time.current.to_s(:long) %></td> 
    </tr>
  </tbody>
</table>

<hr>
<p>

<%= link_to 'Boards', boards_path %>
```

```sh
vim config/routes.rb
```

```rb
root :to => "pages#about"
```

```sh
rails db:migrate
./run.sh
```

## Add Rake Task

```sh
vim lib/tasks/dev.rake
```

```rb
namespace :dev do                                                                                                      
  desc "Clean log and temp files"                                                                                      
  task :clean => ["tmp:clear", "log:clear"]                                                                            
                                                                                                                       
  desc "Rebuild System"                                                                                                
  task :rebuild => [ "dev:clean", "db:migrate", "db:seed" ]                                                            
                                                                                                                       
  desc "Drop and Create Database"                                                                                      
  task :recreate=> ["db:drop", "db:create"]                                                                            
end
```

## Scaffold Boards Posts

```sh
rails generate scaffold board name:string
rails generate scaffold post title:string content:text
rails db:migrate
./run.sh
```

## Create Seed

```sh
vim db/seed.rb
```

```rb
5.times do |i|
  Board.create(name: "board ##{i+1}")
  2.times do |j|
    Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}")
  end
end
```

```sh
rails db:seed
```

## Setup Routes

```sh
vim config/routes.rb
```

```rb
root :to => "boards#index"
```

```sh
vim app/views/boards/index.html.erb
```

```rb
 | <%= link_to 'Posts', posts_path %> 
```

```sh
vim app/views/posts/index.html.erb
```

```rb
 | <%= link_to 'Boards', boards_path %> 
```

```sh
./run.sh
```

## Git Commit for Scaffold

```sh
git add .
git commit -m "feat: scaffold board/post"
```

## Add `has many` / `belongs to`

```sh
vim app/moddels/board.rb
```

```rb
has_many :posts
```

```sh
vim app/moddels/post.rb
```

```rb
belongs_to :board
```

## Mirgate `add board id to post`

```sh
rails generate migration add_board_id_to_post board_id:integer
```

```rb
def change
 add_column :posts, :board_id, :integer
end
```

```sh
rails db:migrate
```

## Modify Routes for Nested Resources

```rb
resources :boards do
  resources :posts
end
```

## Git Commit for Add board id

```sh
git add .
git commit -m "feat: add board id to post"
```

## Modify seed for Nested Resources

```sh
vim db/seed.rb
```

```rb
5.times do |i|
  Board.create(name: "board ##{i+1}")
  2.times do |j|
    Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}", board_id: i+1)
  end
end
```

```sh
rails db:reset
```

## Modify board's controller / views for Nested Resources

```sh
vim app/controllers/boards_controller.rb
```

```rb
def show
  set_posts
end
```

```sh
vim app/views/boards/show.html.erb
```

```rb
<% if @posts != nil %>
<h1>Listing Posts</h1>
    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Content</th>
                <th colspan="3"></th>
            </tr>
        </thead>
        <tbody>
            <% @posts.each do |post| %>
            <tr>
                <td><%= post.title %>
                <td><%= post.content %>
                <td><%= link_to 'Show', board_post_path(@board, post) %></td>
                <td><%= link_to 'Edit', edit_board_post_path(@board, post) %></td>
                <td><%= link_to 'Destroy', board_post_path(@board, post), method: :delete, data: { confirm: 'Are you sure?' } %></td>
            </tr>
        <% end %>
    </tbody>
</table>
<% end %>
<br>
<%= link_to 'New Post', new_board_post_path(@board) %> |
<%= link_to 'Edit', edit_board_path(@board) %> |
<%= link_to 'Back', boards_path %> 
```

## Modify posts controller / views for Nested Resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :set_board
before_action :set_post, only: %i[ show edit update destroy ] 

def index                                                                             redirect_to board_path(@board)
end

def new
  @post = @board.posts.build                                                    
end 

def create
  @post = @board.posts.build(post_params)

  respond_to do |format|
    if @post.save
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully created." }           
      format.json { render :show, status: :created, location: @post }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 

def update
  respond_to do |format|
    if @post.update(post_params)
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully updated." }
      format.json { render :show, status: :ok, location: @post }                                                     
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 

def destroy                                                                                                          
  @post.destroy

  respond_to do |format|
    format.html { redirect_to board_posts_path(@board), notice: "Post was successfully destroyed." }
    format.json { head :no_content }
  end 
end 

def set_board
  @board = Board.find(params[:board_id])
end 

def set_post
  @post = @board.posts.find(params[:id])
end 
```

```sh
vim app/views/posts/show.html.erb
```

```rb
<%= link_to 'Edit', edit_board_post_path(@board,@post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

```sh
vim app/views/posts/new.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_posts_path(@board)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Back', board_posts_path(@board) %>
```

```sh
vim app/views/posts/edit.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_post_path(@board, @post)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Show', board_post_path(@board,@post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

```sh
vim app/views/posts/_form.html.erb
```

```rb
<% if @post.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>
    <ul>
    <% @post.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>

<div class="field">
  <%= form.label :title %>
  <%= form.text_field :title, id: :post_title %>
</div>

<div class="field">
  <%= form.label :content %>
  <%= form.text_area :content, id: :post_content %>
</div>

<div class="actions">
  <%= form.submit %>
</div>
```

## Git Commit for Nested Resources Views

```sh
git add .
git commit -m "feat: Modify controllers/viws for nested resources"
```

## Install devise

```sh
vim Gemfile
```

```rb
# Use devise for user management
gem 'devise'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
```

```sh
bundle install
rails generate devise:install
vim config/environments/development.rb
```

```rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```sh
vim config/initializers/devise.rb
```

```rb
config.secret_key = 'xxxxxxxxxx'
``

```sh
vim app/views/layouts/application.html.erb
```

```rb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```

```sh
rails generate:views
rails generate devise user
rails db:migrate
vim app/controllers/boards_controller.rb
```

```rb
before_action :authenticate_user! , only: [:new]
```

```sh
rails generate migration add_name_to_user name:string
```

```rb
class AddNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
  end
end
```

```sh
rails db:migrate
vim app/views/devise/regaistrations/new.html.erb
```

```rb
<div class="field">
  <%= f.label :name %><br />
  <%= f.name_field :name, autofocus: true %>
</div>  
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>  
```

## Git Commit for Install Devise 

```sh
git add .
git commit -m "feat: Install devise"
```

## Add User Navigation Bar

```
mkdir app/views/common
vim app/views/common/_user_nav.html.erb
```

```rb
<div class="user_navigation">
  <% if !current_user %>
    <%= link_to 'Sign in', new_user_session_path %>
    <%= link_to 'Sign up', new_user_registration_path %>
  <% else %>
    Hi! <%= current_user.name %>
    <%= link_to 'Sign out', destroy_user_session_path, :method => :delete %>
  <% end %>
</div>
```

```sh
vim vim app/views/layouts/application.html.erb
```

```rb
<%= render 'common/user_nav' %>
```

## Git Commit for User Navigation Bar 

```sh
git add .
git commit -m "feat: add user navigation bar"
```

## Mirgate `add user id to board`

```sh
rails generate migration add_user_id_to_board user_id:integer
```

```rb
def change
 add_column :boards, :user_id, :integer
end
```

```sh
vim app/models/board.rb
```

```rb
belongs_to :user
```

```sh
vim app/models/user.rb
```

```rb
has_many :boards
```

```sh
rails db:migrate
```

## Git Commit for Add user id

```sh
git add .
git commit -m "feat: add uer id to board"
```

## Modify boards controller / views for User 

```sh
vim app/controllers/boards_controller.rb
```

```rb
before_action :authenticate_user! , only: [:new, :create]

def create
  @board = Board.new(board_params)
  @board.user = current_user

  respond_to do |format|
    if @board.save
      format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
      format.json { render :show, status: :created, location: @b
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @board.errors, status: :unprocessable_entity }
    end
  end
end
```

```sh
vim app/views/boards/index.html.erb
```
```rb
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Creator</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @boards.each do |board| %>
      <tr>
        <td><%= board.name %></td>
        <td><%= board.user.email %></td>
        <td><%= link_to 'Show', board %></td>
        <td><%= link_to 'Edit', edit_board_path(board) %></td>
        <td><%= link_to 'Destroy', board, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```
## Modify seed for create default user 

```sh
vim db/seed.rb
```

```rb
user = User.create! :name => 'admin', :email => 'admin@rails101.org', :password => 'P@ssw0rd9999', :password_confirmation => 'P@ssw0rd9999'
5.times do |i|
  Board.create(name: "board ##{i+1}", user_id: 1)
  2.times do |j|
    Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}", board_id: i+1)
  end
end 
```

```sh
rails db:reset
```

## Only board owner can edit/delete post

```sh
vim app/controllers/boards_controller.rb
```

```rb
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user , only: [:edit, :update, :destroy]

def check_user
  if current_user != @board.user
    redirect_to root_path, alert: "#{current_user.email}, You are no permission."
  end
end
```

```sh
vim app/views/boards/index.html.erb
```

```rb
<tbody>
  <% @boards.each do |board| %>
    <tr>
      <td><%= board.name %></td>
      <td><%= board.user.email %></td>
      <td><%= link_to 'Show', board %></td>
      <% if current_user && current_user == board.user %>
      <td><%= link_to 'Edit', edit_board_path(board) %></td>
      <td><%= link_to 'Destroy', board, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      <% end %>
    </tr>
  <% end %>
</tbody>
```

```sh
vim app/views/boards/show.html.erb
```

```rb
<tbody>
  <% @posts.each do |post| %>
    <tr>
      <td><%= post.title %>
      <td><%= post.content %>
      <td><%= link_to 'Show', board_post_path(@board, post) %></td>
      <% if current_user && current_user == @board.user %>
      <td><%= link_to 'Edit', edit_board_post_path(@board, post) %></td>
      <td><%= link_to 'Destroy', board_post_path(@board, post), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      <% end %>
    </tr>
  <% end %>
</tbody>
```

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :authenticate_user! , except: [:show]
before_action :check_user , only: [:new, :edit, :update, :destroy]

def check_user
  if current_user != @board.user
    redirect_to board_path(@board), alert: "#{current_user.email}, You are no permission to create/update/delete post."
  end
end
```

```sh
vim app/views/posts/show.html.erb
```

```rb
<% if current_user && current_user == @board.user %>
<%= link_to 'Edit', edit_board_post_path(@board, @post) %> |
<% end %>
```

```sh
vim app/views/layouts/application.html.erb
```

```rb
<body>
  <%= render 'common/user_nav' %>
  <!--<p class="notice"><%= notice %></p>-->
  <p class="alert" style="color:red"><%= alert %></p  >
  <%= yield %>
</body>
```

## Git Commit for  boards controller/views

```sh
git add .
git commit -m "feat: modify boards/views for user permission"
```

# Setup Capistrano

## Add deploy user

```sh
sudo adduser --disabled-password deploy
```

## Setup deploy user

```sh
sudo su deploy
ssh-keygen -t rsa -C deploy@server
exit
sudo cp ~/.ssh/id_rsa.pub /tmp/admin.pub
sudo su deploy
cat /tmp/admin.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Setup RVM for deploy

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
source ~/.rvm/scripts/rvm
```

```sh
vim ~/.gemrc
```

```yml
gem: --no-ri --no-rdoc --no-document
```

```sh
rvm install 2.7.2 --disable-install-document
gem update --system
rvm use 2.7.2@rails517 --create --default --ruby-version
gem install rails -v 5.1.7
vim ~/.bashrc
```

```sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*   
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.                                      
export PATH="$PATH:$HOME/.rvm/bin" 
```

```sh
exit
```

## Install Capistrano

```sh
vim Gemfile
```

```rb
gem 'capistrano-rails'
gem 'capistrano-passenger'
gem 'capistrano-rvm'
gem 'ed25519', '>= 1.2'
gem 'bcrypt_pbkdf', '>= 1.0'
gem 'bcrypt', '~> 3.1.7'
# Gemfile
group :development do
  gem 'capistrano-deploytags', '~> 1.0.0', require: false
end
```

```sh
bundle install
```

## Setup Capistrano

```sh
cap install
vim Capfile
```

```rb
require "capistrano/rvm"
require "capistrano/rails"
require 'capistrano/rails/console'
require 'capistrano/deploytags'
require "capistrano/passenger"
```

```sh
vim config/deploy.rb
```

```rb
set :application, "rails101"
set :repo_url, "git@github.com:alexcode-cc/Rails101.git"

set :deploy_to, "/home/deploy/rails101"

append :linked_files, "config/database.yml", 'config/secrets.yml'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

set :keep_releases, 5 

set :passenger_restart_with_touch, true
```

```sh
vim config/deploy/production.rb
```

```rb
set :branch, "main"
server "127.0.0.1", user: "deploy", roles: %w{app db web}, my_property: :my_value
```

```sh
vim config/deploy/staging.rb
```

```rb
set :branch, "main"
server "127.0.0.1", user: "deploy", roles: %w{app db web}, my_property: :my_value
```

Add secrets key to production/staging env
```sh
vim config/secrets.yml
```

```sh
sudo cp config/database.yml /home/deploy/rails101/shared/config/.
sudo chown deploy:deploy /home/deploy/rails101/shared/config/database.yml
sudo cp config/secrets.yml /home/deploy/rails101/shared/config/.
sudo chown deploy:deploy /home/deploy/rails101/shared/config/secrets.yml
cap production deploy:check
```

## Install Passenger

```sh
#sudo apt-get install -y nginx-extras passenger
sudo apt install nginx
```

### Install our PGP key and add HTTPS support for APT
```sh
sudo apt install -y dirmngr gnupg apt-transport-https ca-certificates 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
```

### Add our APT repository
```sh
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'
sudo apt update
```

### Install Passenger + Nginx module
```sh
sudo apt install -y libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
sudo ls /etc/nginx/conf.d/mod-http-passenger.conf
sudo vim /etc/nginx/conf.d/mod-http-passenger.conf
```

```
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /usr/bin/passenger_free_ruby;
passenger_instance_registry_dir /var/run/passenger-instreg;
```

'''sh
sudo /usr/bin/passenger-config validate-install
sudo su deploy
source ~/.rvm/scripts/rvm
rvm use
passenger-config about ruby-command
```

```
passenger-config was invoked through the following Ruby interpreter:
  Command: /home/deploy/.rvm/gems/ruby-2.7.2@rails517/wrappers/ruby
  Version: ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
  To use in Apache: PassengerRuby /home/deploy/.rvm/gems/ruby-2.7.2@rails517/wrappers/ruby
  To use in Nginx : passenger_ruby /home/deploy/.rvm/gems/ruby-2.7.2@rails517/wrappers/ruby
  To use with Standalone: /home/deploy/.rvm/gems/ruby-2.7.2@rails517/wrappers/ruby /usr/bin/passenger start

## Notes for RVM users
Do you want to know which command to use for a different Ruby interpreter? 'rvm use' that Ruby interpreter, then re-run 'passenger-config about ruby-command'.
```

```sh
exit
sudo rm /etc/nginx/sites-enabled/default
sudo vim /etc/nginx/sites-enabled/rails101.conf
```

```
server {
    listen 80;
    server_name 127.0.0.1;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /home/deploy/rails101/current/public;

    # Turn on Passenger
    passenger_enabled on;
    passenger_ruby /home/deploy/.rvm/gems/ruby-2.7.2@rails517/wrappers/ruby;

    passenger_min_instances 1;

    location ~ ^/assets/ {
        expires 1y;
        add_header Cache-Control public;
        add_header ETag "";
        break;
   }
}
```

```sh
sudo service nginx restart
sudo service nginx status
```

# Setup Mysql

Install mysql server
```sh
sudo apt install mysql-common mysql-client libmysqlclient-dev mysql-server
sudo mysql
```

Create databsses and users
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'myrootpassword';
FLUSH PRIVILEGES;
CREATE DATABASE rails101 CHARACTER SET utf8mb4;
CREATE USER 'rails101'@'localhost' IDENTIFIED BY 'rails101password';
GRANT ALL PRIVILEGES ON rails101.* TO 'rails101'@'localhost';
CREATE DATABASE rails101_staging CHARACTER SET utf8mb4;
GRANT ALL PRIVILEGES ON rails101_staging.* TO 'rails101'@'localhost';
```

Add 'mysql' gem
```sh
vim Gemfile
```

```rb
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
 ```

Setup database.yml
```sh
echo config/database.yml >> .gitignore
git rm config/database.yml
git add .
git commit -m "chore: remove database.yml from repo"

vim config/database.yml
```

```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password:
  socket: /var/run/mysqld/mysqld.sock

development:
  <<: *default
  database: rails101_development

test:
  <<: *default
  database: rails101_test

production:
  <<: *default
  database: rails101
  username: rails101
  password: <%= ENV['RAILS101_DATABASE_PASSWORD'] %>  
```

Setup development database
```sh
rails db:create
rails db:migrate
rails db:seed
./run.sh
```

Setup production/staging database
```sh
RAILS_ENV='production' rails db:migrate
RAILS_ENV='production' rails db:seed
RAILS_ENV='production' rails server -b 0.0.0.0
RAILS_ENV='staging' rails db:migrate
RAILS_ENV='staging' rails db:seed
RAILS_ENV='staging' rails server -b 0.0.0.0
```
