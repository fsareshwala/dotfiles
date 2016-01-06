package { [
  'ack',
  'cscope',
  'feh',
  'gdb',
  'htop',
  'offlineimap',
  'strace',
  'tmux',
  'valgrind',
  'xclip',
  'terminus-fonts',
  'terminus-fonts-console',
  'numlockx',
]:
  ensure => installed,
  allow_virtual => true,
}

cron { offlineimap:
  command => 'nice -n 15 offlineimap >> /tmp/offlineimap.cron',
  user => fsareshwala,
  target => fsareshwala,
  minute => '*',
  require => Package['offlineimap'],
}

file { '/home/fsareshwala/.config/mutt-ldap.cfg':
  ensure => link,
  target => '/home/fsareshwala/personal/mutt-ldap.cfg',
  owner => fsareshwala,
  group => fsareshwala,
  mode => 600,
}
