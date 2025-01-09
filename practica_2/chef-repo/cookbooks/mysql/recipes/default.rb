# Instalar el servidor de MySQL
package 'mysql-server' do
    action :install
  end
  
  # Asegurar que el servicio de MySQL esté corriendo y habilitado
  service 'mysql' do
    action [:enable, :start]
    supports status: true, restart: true
  end
  
  # Crear la base de datos y el usuario de WordPress si no existen
  bash 'create-database' do
    code <<-EOH
      mysql -uroot -e "CREATE DATABASE IF NOT EXISTS wordpress;"
      mysql -uroot -e "CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY 'wp_password';"
      mysql -uroot -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
      mysql -uroot -e "FLUSH PRIVILEGES;"
    EOH
    action :run
  end
  