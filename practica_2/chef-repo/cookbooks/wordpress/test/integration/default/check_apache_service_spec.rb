# Configuración de InSpec

# Prueba para verificar que el servicio Apache2 esté habilitado y ejecutándose en Ubuntu
# En sistemas Ubuntu, el servicio se llama 'apache2'
control 'apache-service-ubuntu' do
  impact 1.0
  title 'Verificar que Apache2 esté habilitado y en ejecución en Ubuntu'
  only_if { os[:name] == 'ubuntu' }

  describe service('apache2') do
    it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
    it { should be_running }  # El servicio debe estar en ejecución
  end
end

# Prueba para verificar que el servicio HTTPD esté habilitado y ejecutándose en RedHat/CentOS
# En sistemas RedHat/CentOS, el servicio se llama 'httpd'
control 'httpd-service-redhat' do
  impact 1.0
  title 'Verificar que HTTPD esté habilitado y en ejecución en RedHat/CentOS'
  only_if { os[:name] == 'redhat' }

  describe service('httpd') do
    it { should be_enabled }  # El servicio debe estar habilitado para iniciarse automáticamente
    it { should be_running }  # El servicio debe estar en ejecución
  end
end

# Prueba para verificar que el puerto 80 (HTTP) esté escuchando conexiones
# Esto asegura que el servidor web esté accesible en el puerto predeterminado
control 'port-80-check' do
  impact 1.0
  title 'Verificar que el puerto 80 esté escuchando conexiones'

  describe port(80) do
    it { should be_listening }  # El puerto 80 debe estar escuchando
  end
end
