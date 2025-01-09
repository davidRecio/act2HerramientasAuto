
require 'serverspec'

# Configuración de Serverspec
set :backend, :exec

# Prueba para verificar que PHP esté instalado
# Esto asegura que PHP, un requisito para WordPress, esté disponible en el sistema
describe package('php') do
  it { should be_installed }  # El paquete PHP debe estar instalado
end

# Prueba para verificar que PHP se pueda ejecutar correctamente
# Se ejecuta el comando 'php -v' y se busca la salida que contenga la versión de PHP
describe command('php -v') do
  its(:stdout) { should match /PHP/ }  # La salida debe contener la palabra 'PHP'
end