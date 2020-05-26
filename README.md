# Snowrabbit
Snowrabbit is a looking glass network app that displays latency information between sites. It is useful for a datacenter or regional network to measure latency between all connections. It can also be used for multi-homed networks.


## Installation

### Master

#### Systemd scripts
Deploy the systemd scripts that come with the master in the `systemd` directory. The main service file should be placed in `/etc/systemd/system/` and the default file in `/etc/default/`.  Values should be edited to reflect the current logging and database configuration.

#### /etc/default/snowrabbitio-master
in `/etc/default/snowrabbitio-master` update the following:
```
LOGGER_LEVEL="debug"
LISTEN_PORT=8090
```

#### Database
Decide which database you are going to use. Snowrabbit currently supports sqlite and mysql.

##### Sqlite
Define the following in the default file:
Define the following in the default file:
```
DB_TYPE = "sqlite"
DB_DATABASE_PATH = "/var/lib/db"
```

##### Mysql
Define the following in the default file:
```
DB_TYPE = "mysql"
DB_USER = "snowrabbit"
DB_PASS = "abc123"
DB_HOST = "db.snowrabbit.io"
DB_PORT = "3306"
DB_DATABASE = "snowrabbit"
```

### Probe

#### Systemd scripts
Deploy the systemd scripts that come with the master in the `systemd` directory. The main service file should be placed in `/etc/systemd/system/` and the default file in `/etc/default/`.  Values should be edited to reflect the current logging and database configuration.

#### /etc/default/snowrabbitio-master
```
MASTER_HOST=demo.snowrabbit.io
MASTER_PORT=8090
PROBE_SECRET=abc123. # Secret is obtained after the probe checks in but before it is registered.
PROBE_SITE=nyc1
LOGGER_LEVEL="debug"
```
