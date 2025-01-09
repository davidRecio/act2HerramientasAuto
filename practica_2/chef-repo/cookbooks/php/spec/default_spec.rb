require 'chefspec'

describe 'php::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '18.04',
      cookbook_path: ['./chef-repo/cookbooks']
    ).converge('php::default')
  end

  # Verificar que los paquetes estén instalados
  %w[php php-mysql libapache2-mod-php].each do |pkg|
    it "installs the #{pkg} package" do
      expect(chef_run).to install_package(pkg)
    end
  end

  # Verificar que Apache se reinicie
  it 'restarts apache2 service' do
    execute_resource = chef_run.execute('enable-php')
    expect(execute_resource).to notify('service[apache2]').to(:restart).immediately
  end

  # Verificar que el servicio apache2 esté habilitado y en ejecución
  it 'ensures apache2 service is enabled and running' do
    expect(chef_run).to enable_service('apache2')
    expect(chef_run).to start_service('apache2')
  end
end
