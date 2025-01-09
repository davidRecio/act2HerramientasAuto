# Configuración de InSpec

# Prueba para verificar que el servicio MySQL esté habilitado y ejecutándose en Ubuntu
# En sistemas Ubuntu, el servicio se llama 'mysql'
control 'mysql-service-ubuntu' do
  impact 1.0
  title 'Verificar que MySQL esté habilitado y en ejecución en Ubuntu'
  only_if { os[:name] == 'ubuntu' }

  describe service('mysql') do
    it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
    it { should be_running }  # El servicio debe estar en ejecución
  end
end

# Prueba para verificar que el servicio MariaDB esté habilitado y ejecutándose en RedHat/CentOS
# En sistemas RedHat/CentOS, el servicio se llama 'mariadb'
control 'mariadb-service-redhat' do
  impact 1.0
  title 'Verificar que MariaDB esté habilitado y en ejecución en RedHat/CentOS'
  only_if { os[:name] == 'redhat' }

  describe service('mariadb') do
    it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
    it { should be_running }  # El servicio debe estar en ejecución
  end
end

# Prueba para verificar que la base de datos de WordPress exista
# Se ejecuta un comando SQL para listar las bases de datos y se verifica que 'wordpress' esté en la lista
control 'wordpress-database-check' do
  impact 1.0
  title 'Verificar que la base de datos WordPress exista'

  describe command('mysql -u root -e "SHOW DATABASES;"') do
    its('stdout') { should match /wordpress/ }  # La salida debe contener la base de datos 'wordpress'
  end
end
