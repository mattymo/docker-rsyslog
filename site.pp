$fuel_settings = parseyaml($astute_settings_yaml)

class {"::rsyslog::server":
  enable_tcp => true,
  enable_udp => ture,
  server_dir => '/var/log/',
  port       => 514,
  high_precision_timestamps => true,
  virtual    => str2bool($::is_virtual),
}

#class {"::openstack::logrotate":
#  rotation       => 'weekly',
#  keep           => '4',
#  limitsize      => '100M',
#}