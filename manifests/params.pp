# Class: timezone::params
#
# Defines all the variables used in the module.
#
class timezone::params {
  case $::osfamily {
    'Debian': {
      $package = 'tzdata'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $localtime_file_type = 'file'
      $timezone_file = '/etc/timezone'
      $timezone_file_template = 'timezone/timezone.erb'
      $timezone_file_supports_comment = false
      $timezone_update = 'dpkg-reconfigure -f noninteractive tzdata'
      $timezone_update_arg = false
    }
    'RedHat', 'Linux': {
      $package = 'tzdata'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      if $::operatingsystemmajrelease == '7' {
        $timezone_file = false
        $timezone_update = 'timedatectl set-timezone '
        $timezone_update_arg = true
        $localtime_file_type = 'link'
      } else {
        $timezone_file_template = 'timezone/clock.erb'
        $timezone_file = '/etc/sysconfig/clock'
        $timezone_update = 'tzdata-update'
        $timezone_update_arg = false
        $localtime_file_type = 'file'
      }
    }
    'Gentoo': {
      $package = 'sys-libs/timezone-data'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $localtime_file_type = 'file'
      $timezone_file = '/etc/timezone'
      $timezone_file_template = 'timezone/timezone.erb'
      $timezone_file_supports_comment = true
      $timezone_update = 'emerge --config timezone-data'
      $timezone_update_arg = false
    }
    'Archlinux': {
      $package = 'tzdata'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $localtime_file_type = 'file'
      $timezone_file = false
      $timezone_update = 'timedatectl set-timezone '
      $timezone_update_arg = true
    }
    'Suse': {
      $package = 'timezone'
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $localtime_file_type = 'file'
      $timezone_file = false
      $timezone_update = 'zic -l '
      $timezone_update_arg = true
    }
    'FreeBSD': {
      $package      = undef
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $localtime_file_type = 'file'
      $timezone_file = false
      $timezone_update = false
      $timezone_update_arg = false
    }
    'Darwin': {
      $package      = undef
      $zoneinfo_dir = '/usr/share/zoneinfo/'
      $localtime_file = '/etc/localtime'
      $timezone_file = false
    }
    'OpenBSD': {
      $package      = undef
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
