class mysql {

	$package_list = ["mysql-server"]
	$reset_root_query = "use mysql; update user set Password=PASSWORD(\"$mysql_root_password\") where User=\"root\""

	package { $package_list: 
		ensure 	=> installed ,
		provider=> apt,
	}

	file { "/etc/mysql/my.cnf":
		owner	=> root,
		group	=> root,
		mode	=> 644,
		notify	=> Service["mysql"],
		content	=> template("mysql.cnf.erb"),
		require	=> Package["mysql-server"],
	}

	service { "mysql":
    		ensure  => "running",
    		enable  => "true",
    		require => Package["mysql-server"],
	}

	exec { "reset_root_pasword":
		command	=> "/usr/bin/mysql -uroot -e \"$reset_root_query\"",
		require	=> File["etc/mysql/my.cnf"],
	}

	define createdb( $database, $user, $password ) {
		exec { "create-$database":
      			unless => "/usr/bin/mysql -u$user -p$password $database",
			command => "/usr/bin/mysql -uroot -p$mysql_root_password -e \"create database $database; grant all on $database.* to $user@% identified by '$password';\"",
      			require => Service["mysqld"],
    		}
  	}
}
