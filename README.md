OULibraries.ojs
=========

Open Journal Systems for OU Libraries

Requirements
------------

CentOS 7.x
Apache
MariaDB

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

```
- src: https://github.com/OULibraries/ansible-role-apache2
  version: v2016-08-10.0
  name: OULibraries.apache2

- src: https://github.com/OULibraries/ansible-role-centos7
  version: v2016-08-24.0
  name: OULibraries.centos7

- src: https://github.com/OULibraries/ansible-role-mariadb
  version: v2016-04-08.0
  name: OULibraries.mariadb

- src: https://github.com/OULibraries/ansible-role-postfix-mta
  version: master
  name: OULibraries.postfix-mta

- src: https://github.com/OULibraries/ansible-role-users
  version: v2016-08-10.0
  name: OULibraries.users
```

Example Playbook
----------------

License
-------

TBD

Author Information
------------------

Jason Sherman
