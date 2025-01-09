
require 'serverspec'

# Configuración de Serverspec
set :backend, :exec

# Prueba para verificar que el archivo de configuración de WordPress (wp-config.php) exista
# Este archivo es fundamental para la configuración de WordPress
describe file('/var/www/html/wp-config.php') do
  it { should exist }  # El archivo debe existir
  it { should be_file }  # Debe ser un archivo regular
  it { should be_readable.by('owner') }  # El propietario debe poder leerlo
end

# Prueba para verificar que el archivo principal de WordPress (index.php) exista
# Este archivo es la entrada principal al sitio de WordPress
describe file('/var/www/html/index.php') do
  it { should exist }  # El archivo debe existir
  it { should be_file }  # Debe ser un archivo regular
end
