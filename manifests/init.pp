# Class: timezone
#
# This module manages timezone settings
#
# Parameters:
#   [*timezone*]
#     The name of the timezone.
#     Default: UTC
#
#   [*utc*]
#     Boolean to reflect hardware clock time ('yes' = Universal Time).
#     Set to 'no' if hardware clock has been set to  local time.
#     Currently only implemented for RedHat systems.
#     Default: yes
#
#   [*ensure*]
#     Ensure if present or absent.
#     Default: present
#
#   [*autoupgrade*]
#     Upgrade package automatically, if there is a newer version.
#     Default: false
#
#   [*package*]
#     Name of the package.
#     Only set this, if your platform is not supported or you know, what you're doing.
#     Default: auto-set, platform specific
#
#   [*config_file*]
#     Main configuration file.
#     Only set this, if your platform is not supported or you know, what you're doing.
#     Default: auto-set, platform specific
#
#   [*zoneinfo_dir*]
#     Source directory of zoneinfo files.
#     Only set this, if your platform is not supported or you know, what you're doing.
#     Default: auto-set, platform specific
#
# Actions:
#   Installs tzdata and configures timezone
#
# Requires:
#   Nothing
#
# Sample Usage:
#   class { 'timezone':
#     timezone => 'Europe/Berlin',
#   }
#
# [Remember: No empty lines between comments and class definition]
class timezone (
  $ensure = 'present',
  $timezone = 'UTC',
  $utc = 'yes',
  $autoupgrade = false
) inherits timezone::params {

  validate_bool($autoupgrade)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
      $localtime_ensure = 'link'
      $timezone_ensure = 'file'
    }
    /(absent)/: {
      # Leave package installed, as it is a system dependency
      $package_ensure = 'present'
      $localtime_ensure = 'absent'
      $timezone_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $timezone::params::package:
    ensure => $package_ensure,
  }

  if $timezone::params::timezone_file != false {
    file { $timezone::params::timezone_file:
      ensure  => $timezone_ensure,
      content => template($timezone::params::timezone_file_template),
    }
  }

  file { $timezone::params::localtime_file:
    ensure  => $localtime_ensure,
    target  => "${timezone::params::zoneinfo_dir}${timezone}",
    require => Package[$timezone::params::package],
  }
}
