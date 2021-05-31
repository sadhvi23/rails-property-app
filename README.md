# Prerequisites
 The setups steps expect following tools installed on the system.
 * Github
 * Ruby 2.6.3
 * Rails 6.1.3
 * postgresql

# 1. Check out the repository
  `git clone https://github.com/sadhvi23/rails-property-app.git`

# 2. Create database.yml file
  * `cp config/database.yml.sample` `config/database.yml`
  * postgres username and password need to be modified

# 3. Create and setup the database
  Run the following commands to create and setup the database.

  * `bundle exec rake db:create`
  * `bundle exec rake db:setup`
  * `bundle exec rake db:migrate`

# 4. Install dependencies
  You can install depencies using,
  * `bundle install` command 

# 4. Start the Rails server
 You can start the rails server using the command given below.
 
 * `bundle exec rails s`


# And now you can visit the site with the URL http://localhost:3000

# To configure smtp 
 * Add username and password in environment file
 * https://www.google.com/settings/u/0/security/lesssecureapps enable this permission for your sender email id so that BE can login to your email
