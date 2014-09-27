server 'eng.mnv.kr', user: 'onesup', roles: %w{web app db}# , my_property: :my_value
set :ssh_options, {
  keys: %w(/Users/onesup/.ssh/ids/eng.mnv.kr/onesup/id_rsa),
  forward_agent: false
  # use_agent: false
  # auth_methods: %w(password)
}
set :rails_env, :production
set :application, 'eng'
set :user, "onesup"
set :deploy_to, "/home/onesup/eng"
puts "deploy/production.rb"