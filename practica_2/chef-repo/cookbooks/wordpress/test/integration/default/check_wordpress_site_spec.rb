# InSpec test para verificar que el sitio de WordPress sea accesible en el puerto 80

describe 'WordPress Site' do
  it 'should be accessible on port 80' do
    uri = URI('http://localhost')
    response = http(uri).get
    expect(response.status).to eq(200)  # La respuesta debe ser 200 OK
  end
end
