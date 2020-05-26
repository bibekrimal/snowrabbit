# Snow Rabbit
Snow Rabbit looking glass network app


## Deployment

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
Define the following in 

##### mysql
Define the following in the default file:
```
DB_TYPE = "mysql"
DB_USER = "snowrabbit"
DB_PASS = "abc123"
DB_HOST = "db.snowrabbit.io"
DB_PORT = "3306"
DB_DATABASE = "snowrabbit"
```


### probe

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
