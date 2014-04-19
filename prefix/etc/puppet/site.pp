package { [
  'build-essential',
  'daemontools',
  'daemontools-run',
  'ntp',
  'perl',
]:
  ensure => latest,
}

cron { puppet:
  command => 'sudo puppet apply ~/prefix/etc/puppet/site.pp',
  user => fsareshwala,
  target => fsareshwala,
  hour => '*',
}

cron { offlineimap:
  require => Package['daemontools'],
  command => '/usr/bin/setlock -nx /tmp/offlineimap.lock offlineimap >> /tmp/offlineimap.cron',
  user => fsareshwala,
  target => fsareshwala,
  hour => '*',
}

file { '/service':
  require => Package['daemontools'],
  ensure => link,
  target => '/etc/service',
  owner => root,
  group => root,
}

file { [
  '/home/fsareshwala/prefix',
  '/home/fsareshwala/prefix/etc',
  '/home/fsareshwala/prefix/etc/service',
  '/home/fsareshwala/prefix/etc/service/ntpd',
]:
  ensure => directory,
  require => Package['daemontools'],
}

file { '/home/fsareshwala/prefix/etc/service/ntpd/run':
  ensure => present,
  backup => false,
  owner => fsareshwala,
  group => fsareshwala,
  mode => 700,
  require => File['/home/fsareshwala/prefix/etc/service/ntpd'],
  content => '#!/bin/sh
exec /usr/sbin/ntpd -n -g -u 113:121
'
}

service { 'ntpd':
  require => File['/home/fsareshwala/prefix/etc/service/ntpd/run'],
  provider => 'daemontools',
  path => '/home/fsareshwala/prefix/etc/service',
  enable => true,
  ensure => running,
  subscribe => [File['/home/fsareshwala/prefix/etc/service/ntpd/run'], Package['ntp']],
}
