server 'm11.mnv.kr', user: 'onesup', roles: %w{web app db}# , my_property: :my_value
set :ssh_options, {
  keys: %w(/Users/daul/.ssh/ids/m11.mnv.kr/onesup/id_rsa),
  forward_agent: false
  # use_agent: false
  # auth_methods: %w(password)
}
set :rails_env, :production
set :application, 'big_coupon'
set :user, "onesup"
set :deploy_to, "/home/onesup/www/big_coupon"
puts "deploy/production.rb"