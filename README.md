# BabyLO

code by https://github.com/whoknows/BabyLO
update docker https://github.com/whoknows/BabyLO

BabyLO is a web-based application for statistics on table football games.
The application is based on Symfony2.
The bookstores used are:

* Bootstrap 3
* HighCharts
* jQuery
* Chosen
* Pickadate.js

### Screenshots

Home  
![alt tag](http://i.imgur.com/W1fjD1il.png)

Advanced Statistics
![alt tag](http://i.imgur.com/Ya76QHHl.png)

Party management
![alt tag](http://i.imgur.com/Io23umVl.png)

## Installation

```bash
git clone https://github.com/whoknows/BabyLO.git
```

A docker image exists to launch the application:

### Run the application in a standalone container

The application need a mysql server in order to work properly.

```bash
sudo docker run --name=db -e MYSQL_ROOT_PASSWORD=root -d mysql
# initialise database (only on first lauch)
sudo docker run --name=web --link=db --rm germanium/babylo init

sudo docker run -v 80:80 --link=db -d germanium/babylo
```

### With docker-compose

The example configuration can be found in docker-compose.yml and run by the following command

```bash
sudo docker-composer up -d (sudo or not sudo depending on your permissions)
docker exec babylo php /app/app/console doctrine:database:create
docker exec babylo php /app/app/console doctrine:schema:update --force
docker exec babylo php /app/app/console doctrine:fixtures:load
curl http://localhost
```

### Build the dev image

```bash
cd BabyLO/
sudo docker build -t babylo .
sudo docker run -v 80:80 babylo
```

### Default Admin credentials

* login : admin
* password : secret

### Public / Private mode

By default the application is in private mode, i. e. you must be authenticated to access it.
It is possible to make it public (excluding admin parts) by commenting line 40 of the app/config/security. yml file:

```bash
- { path: ^/.*, roles: [IS_AUTHENTICATED_FULLY, IS_AUTHENTICATED_REMEMBERED] }
```
