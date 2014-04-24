class timezone::params {
  case $::osfamily {
    'Debian', 'RedHat': {
      $package = 'tzdata'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $timezone_file = '/etc/timezone'
    }
    'Gentoo': {
      $package = 'sys-libs/timezone-data'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $timezone_file = '/etc/timezone'
    }
    'Archlinux': {
      $package = 'tzdata'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $timezone_file = false
    }
    default: {
      case $::operatingsystem {
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
