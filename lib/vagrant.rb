# Install vagrant plugin
#
# @param: plugin type: Array[String] desc: The desired plugin to install
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |plugin|
      plugin_name = plugin['name']
      manager = Vagrant::Plugin::Manager.instance

      next if manager.installed_plugins.has_key?(plugin_name)

      logger.warn("Installing plugin #{plugin_name}")

      manager.install_plugin(
          plugin_name,
          sources: plugin.fetch('source', %w(https://rubygems.org/ https://gems.hashicorp.com/)),
          version: plugin['version']
      )

      installed = true
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

def nfs_path(path)
  "/vagrant-nfs-#{File.basename(path)}"
end