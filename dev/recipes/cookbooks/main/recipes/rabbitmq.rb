include_recipe "rabbitmq"

rabbitmq_plugin "rabbitmq_management" do
	action :enable
end
# node.set['rabbitmq']['enabled_plugins'] = ['rabbitmq_management']

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_user "amigo" do
  password "42Amigo_Rabbit"
  action :add
end

rabbitmq_user "amigo" do
  vhost "/"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user "amigo" do
  tag "administrator"
  action :set_tags
end