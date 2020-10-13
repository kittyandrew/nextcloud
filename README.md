# nextcloud
### Requirements
You need to have:
  - docker
  - docker-compose

### Setup
Clone the repo:  
```shell
git clone git@github.com:kittyandrew/nextcloud.git
```
  
Copy config and fill it:  
```shell
cp empty-nextcloud.env .env
# [editor of your choice]
vim .env
```
Currently in config all you need is create 3 passwords and 2 names. Preferrably use some kind of password manager to save this values, since if you lose access to file, you cannot open database.  
  
Finally to launch:
```shell
docker-compose up -d --build
```

### Donation
BTC: `1GWbPkBJgugcu3pRf8HFgq4GqJ7QCazwNS`
