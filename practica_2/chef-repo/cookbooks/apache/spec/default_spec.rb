require 'chefspec'

describe 'apache::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '18.04',
      cookbook_path: ['./chef-repo/cookbooks']  # Ruta correcta a tu directorio de cookbooks
    ) do |node|
      # Simular la configuración de la VM según el Vagrantfile
      node.normal['memory'] = { 'total' => '1024MB' }  # Configuración de memoria de Vagrant
      node.normal['network'] = {
        interfaces: {
          'enp0s8' => {
            addresses: {
              '192.168.33.40' => { family: 'inet' }  # Dirección IP de la red privada en el Vagrantfile
            }
          }
        }
      }
      node.normal['apache'] = { 'listen_ports' => ['80'] }  # Configuración de puertos de apache
    end.converge(described_recipe)
  end

  it 'installs apache2' do
    expect(chef_run).to install_package('apache2')
  end

  it 'starts the apache2 service' do
    expect(chef_run).to start_service('apache2')
  end

  it 'enables the apache2 service' do
    expect(chef_run).to enable_service('apache2')
  end
end
