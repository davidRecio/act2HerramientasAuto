# Instala PHP, el módulo de PHP para Apache y MySQL
package ['php', 'php-mysql', 'libapache2-mod-php'] do
    action :install
  end
  
  # Habilita el módulo de PHP y reinicia Apache
  execute 'enable-php' do
    command 'systemctl restart apache2'
    action :run
    environment({ 'PATH' => '/bin:/usr/bin' })  # Define el PATH correctamente
    notifies :restart, 'service[apache2]', :immediately
    only_if { ::File.exist?('/etc/apache2/mods-available/php.conf') }
  end
  
  # Asegúrate de que Apache esté en ejecución
  service 'apache2' do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
  