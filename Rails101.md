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

## Install Rails 5.1.7

```sh
gem install rails -v 5.1.7
```

## Create GemSet

```sh
rvm use 2.7.2@rails517 --create --default --ruby-version
```

## Setup UFW

```sh
sudo ufw allow from 192.168.0.0/24
sudo ufw enable
```

## Clone Rails101

```sh
git clone git@github.com:alexcode-cc/Rails101.git
cd rails101
bundle
rails db:migrate
rails db:seed
rails server -b 0.0.0.0
```

# Setup Rails102

## Create New Project

```sh
rails new rails102
cp .ruby-gemset rails102/.
cp .ruby-version rails102/.
cd rails102
bundle
echo rails server -b 0.0.0.0 >> run.sh
chmod u+x run.sh
./run.sh
```

## Init Git

```sh
git add .
git commit -m "Initial commit"
git flow init
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
    Hi! <%= current_user.email %>
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
