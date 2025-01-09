# Variables de configuración de la base de datos
db_name = 'wordpress'
db_user = 'wp_user'
db_password = 'wp_password'
db_host = 'localhost'

# Instalar paquetes necesarios
%w[apache2 php mysql-server].each do |pkg|
  package pkg do
    action :install
  end
end

# Crear directorio de instalación
directory '/var/www/html' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
  recursive true
end

# Descargar y extraer WordPress
remote_file '/tmp/wordpress.tar.gz' do
  source 'https://wordpress.org/latest.tar.gz'
  action :create
  not_if { ::File.exist?('/tmp/wordpress.tar.gz') }
end

bash 'extract-wordpress' do
  code <<-EOH
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
  EOH
  creates '/var/www/html/wp-config-sample.php'
  not_if { ::File.exist?('/var/www/html/wp-config-sample.php') }
  action :run
end

# Asegurar que los permisos sean correctos
template '/var/www/html/wp-config.php' do
  source 'wp-config.php.erb'
  owner 'www-data'
  group 'www-data'
  mode '0644'
  notifies :restart, 'service[apache2]', :immediately
  action :create
end

# Habilitar el sitio de Apache
execute 'enable-site' do
  command '/usr/sbin/a2ensite vagrant.conf'
  not_if 'apache2ctl -S | grep vagrant.conf'
  action :run
end

# Deshabilitar el sitio predeterminado
execute 'disable-default-site' do
  command '/usr/sbin/a2dissite 000-default.conf'
  not_if 'apache2ctl -S | grep -q "000-default.conf"'
  action :run
end

# Cambiar la propiedad de los archivos
execute 'change-ownership' do
  command 'chown -R www-data:www-data /var/www/html'
  not_if 'ls -ld /var/www/html | grep "www-data www-data"'
  action :run
end

# Cambiar los permisos de los archivos
execute 'change-permissions' do
  command 'chmod -R 755 /var/www/html'
  not_if 'ls -ld /var/www/html | grep "755"'
  action :run
end

# Habilitar el módulo de reescritura de Apache
execute 'enable-rewrite-module' do
  command '/usr/sbin/a2enmod rewrite'
  not_if 'apache2ctl -M | grep rewrite_module'
  action :run
end

# Asegurar que Apache esté habilitado y en ejecución
service 'apache2' do
  action [:enable, :start]
  supports status: true, restart: true
end

# Instalar WP-CLI
remote_file '/usr/local/bin/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  mode '0755'
  not_if { ::File.exist?('/usr/local/bin/wp') }
end

# Completar la configuración inicial de WordPress usando wp-cli
bash 'initialize-wordpress' do
  code <<-EOH
    /usr/local/bin/wp core install --url="http://localhost" --title="Mi Blog" --admin_user="admin" --admin_password="password" --admin_email="admin@example.com" --path=/var/www/html --allow-root
  EOH
  cwd '/var/www/html'
  not_if '/usr/local/bin/wp core is-installed --path=/var/www/html'
  action :run
end
