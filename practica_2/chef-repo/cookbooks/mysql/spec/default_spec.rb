require 'chefspec'

describe 'mysql::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '18.04',
      cookbook_path: ['./chef-repo/cookbooks']  # Ruta correcta a tu directorio de cookbooks
    ) do |node|
      # Aquí puedes definir cualquier configuración adicional del nodo si es necesario.
    end.converge(described_recipe )  # Nombre de la receta a ejecutar
  end

  it 'installs the mysql-server package' do
    expect(chef_run).to install_package('mysql-server')
  end

  it 'enables the mysql service' do
    expect(chef_run).to enable_service('mysql')
  end

  it 'starts the mysql service' do
    expect(chef_run).to start_service('mysql')
  end
end
