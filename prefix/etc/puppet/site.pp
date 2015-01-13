package { [
  'ack-grep',
  'build-essential',
  'cscope',
  'daemontools',
  'daemontools-run',
  'exim4',
  'exuberant-ctags',
  'feh',
  'gdb',
  'htop',
  'libldap2-dev',
  'libnotify-bin',
  'libsasl2-dev',
  'lxappearance',
  'nodm',
  'ntp',
  'offlineimap',
  'perl',
  'python-pip',
  'strace',
  'tig',
  'tmux',
  'valgrind',
  'weechat',
  'weechat-scripts',
  'xclip',
  'xfonts-terminus',
  'puppet',
]:
  ensure => installed,
}

cron { puppet:
  command => 'sudo puppet apply ~/prefix/etc/puppet/site.pp',
  user => fsareshwala,
  target => fsareshwala,
  minute => '*',
  require => Package['puppet'],
}

cron { offlineimap:
  command => 'nice -n 15 offlineimap >> /tmp/offlineimap.cron',
  user => fsareshwala,
  target => fsareshwala,
  minute => '*',
  require => Package['offlineimap'],
}

cron { ntpd:
  command => 'sudo ntpd -qg',
  user => fsareshwala,
  target => fsareshwala,
  minute => '*/5',
  require => Package['ntp'],
}

file { [
  '/etc/service/ntpd',
]:
  ensure => directory,
  require => [Package['ntp'], Package['daemontools-run']],
}

file { '/etc/service/ntpd/run':
  ensure => present,
  backup => false,
  owner => root,
  group => root,
  mode => 755,
  require => File['/etc/service/ntpd'],
  content => '#!/bin/sh
exec /usr/sbin/ntpd -n -g -u 113:121
'
}

file { '/etc/default/nodm':
  ensure => present,
  backup => false,
  owner => root,
  group => root,
  mode => 644,
  require => Package['nodm'],
  content => "# nodm configuration

# Set NODM_ENABLED to something different than 'false' to enable nodm
NODM_ENABLED=true

# User to autologin for
NODM_USER=fsareshwala

# First vt to try when looking for free VTs
NODM_FIRST_VT=7

# X session
NODM_XSESSION=/etc/X11/Xsession

# Options for the X server
NODM_X_OPTIONS='-nolisten tcp'

# If an X session will run for less than this time in seconds, nodm will wait an
# increasing bit of time before restarting the session.
NODM_MIN_SESSION_TIME=60
"
}

file { '/etc/exim4/passwd.client':
  ensure => link,
  target => '/home/fsareshwala/personal/exim4.passwd',
  owner => root,
  group => root,
  mode => 600,
  require => Package['exim4']
}

file { '/etc/X11/default-display-manager':
  ensure => present,
  backup => false,
  owner => root,
  group => root,
  mode => 644,
  require => Package['nodm'],
  content => "/usr/sbin/nodm"
}

file { '/etc/apt/sources.list.d/atlassian-hipchat.list':
  ensure => present,
  backup => false,
  owner => root,
  group => root,
  mode => 644,
  content => 'deb http://downloads.hipchat.com/linux/apt stable main'
}

file { '/etc/apt/sources.list.d/backports.list':
  ensure => present,
  backup => false,
  owner => root,
  group => root,
  mode => 644,
  content => 'deb http://ftp.debian.org/debian wheezy-backports main contrib non-free
deb-src http://ftp.debian.org/debian wheezy-backports main contrib non-free'
}

service { 'ntpd':
  require => File['/etc/service/ntpd/run'],
  provider => 'daemontools',
  path => '/etc/service',
  enable => true,
  ensure => running,
  subscribe => [File['/etc/service/ntpd/run'], Package['ntp']],
}
