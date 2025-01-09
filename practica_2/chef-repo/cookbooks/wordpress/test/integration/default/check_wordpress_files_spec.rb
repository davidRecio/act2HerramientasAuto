# InSpec test para verificar archivos y configuraciones de WordPress

# Verificar que el directorio principal de WordPress exista
describe file('/var/www/html') do
  it { should be_directory }  # El directorio debe existir
end

# Verificar que el archivo de configuración de WordPress (wp-config.php) exista y tenga las propiedades correctas
describe file('/var/www/html/wp-config.php') do
  it { should exist }  # El archivo debe existir
  it { should be_file }  # Debe ser un archivo regular
  it { should be_readable.by('owner') }  # El propietario debe poder leerlo
  it { should be_owned_by 'www-data' }  # Verificar que el propietario sea el usuario adecuado
  it { should be_mode 644 }  # Verificar que los permisos sean correctos
end

# Verificar que el archivo principal de WordPress (index.php) exista y tenga las propiedades correctas
describe file('/var/www/html/index.php') do
  it { should exist }  # El archivo debe existir
  it { should be_file }  # Debe ser un archivo regular
  it { should be_owned_by 'www-data' }  # Verificar que el propietario sea el usuario adecuado
  it { should be_mode 644 }  # Verificar que los permisos sean correctos
end
