# nextcloud
### Features
- Ultimately easy to deploy  
- Supports Mautoolz extention ([Coming soon to nextcloud app store..](https://github.com/kittyandrew/nextcloud-mautoolz))
    * Compression of pdf files
    * Conversion of documents (.doc, .docx, .odt, etc) to pdf
    * Conversion of epub to pdf (`unstable`)
- This build has ffmpeg installed (Supports [Video converter](https://apps.nextcloud.com/apps/video_converter))
- This build has youtube-dl installed (Supports [ocDownloader](https://apps.nextcloud.com/apps/ocdownloader))
  
### Requirements
You need to have:
  - docker
  - docker-compose

### Setup
Clone the repo:  
```shell
git clone git@github.com:kittyandrew/nextcloud.git
```
  
Get into project dir
```shell
cd nextcloud
```
  
Copy config and fill it:  
```shell
cp empty-nextcloud.env .env
# [editor of your choice]
vim .env
```
Currently in config all you need is to create 3 passwords and 2 names. Preferrably use some kind of password manager to save this values, since if you lose access to the `.env` file, you cannot open the database.  
Note: if you are using the reverse proxy, **don't** change the schema to `http` in the `.env` file. Only do it if **your proxy is http**. (Even then, choosing to use http only is accepting that you give up your privacy and security)  
  
Finally, to launch:
```shell
docker-compose up -d --build
```
  
### License
[LICENSE](./LICENSE)  

### Donation
BTC: `1GWbPkBJgugcu3pRf8HFgq4GqJ7QCazwNS`
