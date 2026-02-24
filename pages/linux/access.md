---
layout: page
title: User Management on Linux
---
* Login methods (local, SSH)
# Users
## Discover 
* `cat /etc/passwd | cut -d: -f1` -- list all users
* `grep -vE "nologin|false" /etc/passwd | cut -d: -f1` -- list all users with login capability 
* `cat /etc/passwd | cut -d: -f 1,3 | grep -E ':[0-9]{4,}'` -- OR, using UID >= 1000
* `getent passwd | grep -vE "nologin|false" | cut -d: -f1` -- list all users with login capability and includes LDAP or NIS
* `grep 'new user:name=username' /var/log/auth.log` -- when was user created
* `zgrep 'new user:name=username' /var/log/auth.log` -- OR, if log have be recycled, checking archive
* `stat /home/username` -- OR, workaround if home directory hasnt been moved, check Birth details
* `lastlog -u username` when did user logged last
* `sudo lastb | grep username` -- login records
## Manage
* adduser -- preferred over useradd which is low level utility 
* usermod -- modify user
# Groups
	 
* Root access vs sudo
* Permissions & ownership
* Filesystem hierarchy understanding
* Key config and logging
# Ref 
## User Info 
* /etc/passwd
* /etc/shadow 
* /etc/login.defs 
## Group 
* /etc/group 
* /etc/gshadow 
## Privilege 
* /etc/sudoers 
## Home Skeleton 
* /etc/skel/
## Authentication Logs
* /var/log/auth.log 