# Install Ubuntu 20.04 LTS

## Install openssh-server

<pre>
sudo apt install openssh-server
</pre>

## Install ssh Key

<pre>
ssh-keygen -t rsa -C user@ubuntu
</pre>

## Enabld authorized_keys

<pre>
cat /tmp/key.pub >> authorized_keys
chmod 600 authorized_keys
</pre>

## Setup aliases

<pre>
vim ~/.bash_aliases
</pre>

<pre>
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias vin='vim +NERDTree'
</pre>

<pre>
source ~/.bash_aliases
</pre>

## Update Ubuntu

<pre>
update
</pre>

## Install Tools

<pre>
sudo apt install git git-flow vim curl wget gpg w3m
</pre>

# Setup Ubuntu

## Setup Git

<pre>
git config --global user.name user
git config --global user.email user.mail
git config --global core.editor vim
git config --global ui.color true
</pre>

## Setup Vim

<pre>
git clone git@github.com:alexcode-cc/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone git@github.com:lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8
wget https://raw.githubusercontent.com/alexcode-cc/myconfig/main/.vimrc ~/.vimrc
vim
</pre>

<pre>
:PluginInstall!
</pre>

## Setup RVM

<pre>
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
</pre>

## Install Ruby 2.7.2

<pre>
vim ~/.gemrc
</pre>

<pre>
gem: --no-ri --no-rdoc --no-document
</pre>

<pre>
rvm install 2.7.2 --disable-install-document
gem update --system
ruby -v
</pre>

ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]

<pre>
gem -v
</pre>

3.4.7

## Install Node 16.9.1

<pre>
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs
sudo npm install -g npm
sudo npm install -g yarn
node -v
</pre>

v16.19.1

<pre>
npm -v
</pre>

9.5.1

<pre>
yarn -v
</pre>
1.22.19

## Install Rails 5.1.7

<pre>
gem install rails -v 5.1.7
</pre>

## Create GemSet

<pre>
rvm use 2.7.2@rails517 --create --default --ruby-version
</pre>

## Setup UFW

<pre>
sudo ufw allow from 192.168.0.0/24
sudo ufw enable
</pre>

## Clone Rails101

<pre>
git clone git@github.com:alexcode-cc/rails101.git
cd rails101
bundle
rails db:migrate
rails db:seed
rails server -b 0.0.0.0
</pre>

# Setup Rails102

## Create New Project

<pre>
rails new rails102
cd rails102
bundle
rails server -b 0.0.0.0
</pre>

## Setup Git

<pre>
git add .
git commit -m "Initial commit"
git flow init
</pre>

## Scaffold Boards Posts

<pre>
rails generate scaffold board name:string
rails generate scaffold post title:string content:text
rails db:migrate
echo rails server -b 0.0.0.0 >> run.sh
chmod u+x run.sh
./run.sh
</pre>

## Create Seed

<pre>
vim db/seed.ruby
</pre>

<pre>
5.times do |i|
  Board.create(name: "board ##{i+1}")
  2.times do |j|
    Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}")
  end
end
</pre>

<pre>
rails db:seed
</pre>

## Setup Routes

<pre>
vim config/routes.rb
</pre>

<pre>
root :to => "boards#index"
</pre>

<pre>
./run.sh
</pre>

## Git Commit for Scaffold

<pre>
git add .
git commit -m "feat: scaffold board/post"
</pre>

## Has many / Belongs to

<pre>
vim app/moddels/board.rb
</pre>

<pre>
has_many :posts
</pre>

<pre>
vim app/moddels/post.rb
</pre>

<pre>
belongs_to :boards
</pre>

## Mirgate Add Board Id

<pre>
rails generate migration add_board_id_to_post board_id:integer
</pre>

<pre>
   def change
	add_column :posts, :board_id, :integer
   end
</pre>

<pre>
rails db:migrate
</pre>

## Modify Routes for Nested Resources

<pre>
resources :boards do
  resources :posts
end
</pre>

## Git commit for add board id

<pre>
git add .
git commit -m "feat: add board id to post"
</pre>