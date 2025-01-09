require 'serverspec'

# Configuración de Serverspec
set :backend, :exec

# Prueba para verificar que el servicio MySQL esté habilitado y ejecutándose en Ubuntu
# En sistemas Ubuntu, el servicio se llama 'mysql'
describe service('mysql'), if: os[:family] == 'ubuntu' do
  it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
  it { should be_running }  # El servicio debe estar en ejecución
end

# Prueba para verificar que el servicio MariaDB esté habilitado y ejecutándose en RedHat/CentOS
# En sistemas RedHat/CentOS, el servicio se llama 'mariadb'
describe service('mariadb'), if: os[:family] == 'redhat' do
  it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
  it { should be_running }  # El servicio debe estar en ejecución
end

# Prueba para verificar que la base de datos de WordPress exista
# Se ejecuta un comando SQL para listar las bases de datos y se verifica que 'wordpress' esté en la lista
describe command('mysql -u root -e "SHOW DATABASES;"') do
  its(:stdout) { should match /wordpress/ }  # La salida debe contener la base de datos 'wordpress'
end