require 'chefspec'
require 'chefspec/berkshelf'

describe 'wordpress::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '20.04',
      cookbook_path: ['./chef-repo/cookbooks']  # Ruta al directorio que contiene el cookbook
    ).converge('wordpress::default')
  end

  before do
    # Stubbing external commands
    stub_command('apache2ctl -S | grep -q "000-default.conf"').and_return(false)
    stub_command('apache2ctl -S | grep vagrant.conf').and_return(false)
    stub_command('ls -ld /var/www/html | grep "www-data www-data"').and_return(false)
    stub_command('ls -ld /var/www/html | grep "755"').and_return(false)
    stub_command('apache2ctl -M | grep rewrite_module').and_return(false)
    stub_command('/usr/local/bin/wp core is-installed --path=/var/www/html').and_return(false)
  end

  # Instalación de paquetes
  it 'instala apache2' do
    expect(chef_run).to install_package('apache2')
  end

  it 'instala php' do
    expect(chef_run).to install_package('php')
  end

  it 'instala mysql-server' do
    expect(chef_run).to install_package('mysql-server')
  end

  # Configuración y servicios
  it 'habilita el servicio apache2' do
    expect(chef_run).to enable_service('apache2')
    expect(chef_run).to start_service('apache2')
  end

  it 'ejecuta el script de configuración inicial' do
    expect(chef_run).to run_bash('initialize-wordpress')
  end

  # Creación de directorios
  it 'crea el directorio /var/www/html' do
    expect(chef_run).to create_directory('/var/www/html').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0755'
    )
  end

  it 'crea el directorio /var/www/html/wordpress' do
    expect(chef_run).to create_directory('/var/www/html/wordpress').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0755'
    )
  end

  # Archivo wp-config.php
  it 'crea el archivo wp-config.php dentro de wordpress' do
    expect(chef_run).to create_template('/var/www/html/wordpress/wp-config.php').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0644'
    )
  end

  # Descarga y extracción de WordPress
  it 'descarga el archivo de WordPress' do
    expect(chef_run).to create_remote_file('/tmp/wordpress.tar.gz').with(
      source: 'https://wordpress.org/latest.tar.gz'
    )
  end

  # it 'extrae el archivo de WordPress' do
  #   expect(chef_run).to run_execute('extract_wordpress').with(
  #     command: 'tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1'
  #   )
  #   expect(chef_run).to create_file('/var/www/html/wordpress/wp-config.php')  # Verifica que wp-config.php esté dentro de wordpress
  # end
  

  # Reinicio del servicio apache2
  it 'reinicia el servicio apache2 después de la configuración de WordPress' do
    expect(chef_run).to restart_service('apache2')
  end
end
