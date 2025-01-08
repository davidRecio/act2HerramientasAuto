# Actualiza los repositorios antes de instalar cualquier paquete
apt_update 'Update the apt cache daily' do
  frequency 86400
  action :update
end

# Forzar la instalación de dependencias faltantes antes de continuar
execute 'force-install-dependencies' do
  command 'apt-get install -f'
  user 'root'
  action :run
end

# Instala Apache sin los paquetes recomendados como ssl-cert
package 'apache2' do
  options '--no-install-recommends'
  action :install
  notifies :run, 'execute[force-install-dependencies]', :immediately
end

# Asegúrate de que Apache esté habilitado y en ejecución
service 'apache2' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

# Elimina la configuración predeterminada de Apache
file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  only_if { ::File.exist?('/etc/apache2/sites-enabled/000-default.conf') }
end

# Crea un archivo de configuración virtual para Apache
template '/etc/apache2/sites-available/vagrant.conf' do
  source 'virtual-hosts.conf.erb'
  variables(
    document_root: '/var/www/html'  # Define el DocumentRoot para WordPress
  )
  notifies :reload, 'service[apache2]', :immediately
end

# Crea un enlace simbólico para habilitar el sitio
link '/etc/apache2/sites-enabled/vagrant.conf' do
  to '/etc/apache2/sites-available/vagrant.conf'
  notifies :reload, 'service[apache2]', :immediately
end

# Transfiere el archivo index.html a la carpeta raíz de Apache
cookbook_file '/var/www/html/index.html' do
  source 'index.html'
  only_if { ::File.exist?('/etc/apache2/sites-enabled/vagrant.conf') }
end

# Asegúrate de que WordPress se haya colocado en el directorio correcto
execute 'install-wordpress' do
  command 'wget https://wordpress.org/latest.tar.gz -P /var/www/html && tar -xvzf /var/www/html/latest.tar.gz -C /var/www/html && rm /var/www/html/latest.tar.gz'
  user 'root'
  not_if { ::File.exist?('/var/www/html/wordpress') }
  notifies :reload, 'service[apache2]', :immediately
end

# Incluye la receta de facts si es necesaria
include_recipe '::facts'
