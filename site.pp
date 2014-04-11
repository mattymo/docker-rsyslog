$fuel_settings = parseyaml($astute_settings_yaml)
$fuel_version = parseyaml($fuel_version_yaml)

if is_hash($::fuel_version) and $::fuel_version['VERSION'] and $::fuel_version['VERSION']['production'] {
  $production = $::fuel_version['VERSION']['production']
}
else {
  $production = 'docker-build'
}

class {"::rsyslog::server":
  enable_tcp => true,
  enable_udp => true,
  server_dir => '/var/log/',
  port       => 514,
  high_precision_timestamps => true,
  virtual    => str2bool($::is_virtual),
}

class {"::openstack::logrotate":
  rotation       => 'weekly',
  keep           => '4',
  limitsize      => '100M',
}
