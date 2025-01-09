
require 'serverspec'
require 'net/http'

# Configuración de Serverspec
set :backend, :exec

# Prueba para verificar que el sitio de WordPress sea accesible en el puerto 80
# Se realiza una solicitud HTTP a 'http://localhost' y se espera una respuesta 200 (OK)
describe 'WordPress Site' do
  it 'should be accessible on port 80' do
    uri = URI('http://localhost')
    response = Net::HTTP.get_response(uri)
    expect(response.code).to eq('200')  # La respuesta debe ser 200 OK
  end
end