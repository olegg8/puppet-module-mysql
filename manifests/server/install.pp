class mysql::server::install (
  $mysql_root_password,
  $mysql_root_user,
) {
  user { $mysql::variables::mysql_user:
    uid  => '411',
    gid  => $mysql::variables::mysql_group,
    home => $mysql::variables::mysql_home,
  }
  group { $mysql::variables::mysql_group:
    gid => '411',
  }
  package { [ 'percona-xtradb-cluster-server-5.5', 'percona-xtrabackup' ]:
    ensure  => present,
    require => User[ $mysql::variables::mysql_user ],
  }
  exec { 'init_mysql_rootpw':
    command => "mysqladmin -u root password ${mysql_root_password}",
    unless  => 'test -f /root/.my.cnf',
    require => Package[ 'percona-xtradb-cluster-server-5.5' ],
  }
}