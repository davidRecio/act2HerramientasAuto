require 'serverspec'

# Configuración de Serverspec
set :backend, :exec

# Prueba para verificar que el servicio Apache2 esté habilitado y ejecutándose en Ubuntu
# En sistemas Ubuntu, el servicio se llama 'apache2'
describe service('apache2'), if: os[:family] == 'ubuntu' do
  it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
  it { should be_running }  # El servicio debe estar en ejecución
end

# Prueba para verificar que el servicio HTTPD esté habilitado y ejecutándose en RedHat/CentOS
# En sistemas RedHat/CentOS, el servicio se llama 'httpd'
describe service('httpd'), if: os[:family] == 'redhat' do
  it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
  it { should be_running }  # El servicio debe estar en ejecución
end

# Prueba para verificar que el puerto 80 (HTTP) esté escuchando conexiones
# Esto asegura que el servidor web esté accesible en el puerto predeterminado
describe port(80) do
  it { should be_listening }  # El puerto 80 debe estar escuchando
end
