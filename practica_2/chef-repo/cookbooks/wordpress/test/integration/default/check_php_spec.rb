# Configuración de InSpec

# Prueba para verificar que PHP esté instalado
control 'php-package-check' do
  impact 1.0
  title 'Verificar que PHP esté instalado'
  desc 'Asegura que PHP, un requisito para WordPress, esté disponible en el sistema.'

  describe package('php') do
    it { should be_installed }  # El paquete PHP debe estar instalado
  end
end

# Prueba para verificar que PHP se pueda ejecutar correctamente
control 'php-execution-check' do
  impact 1.0
  title 'Verificar que PHP se pueda ejecutar correctamente'
  desc 'Ejecuta el comando "php -v" para confirmar que PHP está instalado y funcionando.'

  describe command('php -v') do
    its('stdout') { should match /PHP/ }  # La salida debe contener la palabra 'PHP'
  end
end
