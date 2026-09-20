
## Restoring
Install docker, docker compose and make sure you can run it without elevated root privilages
Install borg and run the restore command in each sub directory

Make sure you pull all docker images to the latest version

After all services are up, change the provider url in authentik so oauth can work in the applications again(in case the ip/domain changed)


## Notes
### wake on lan
make sure to enable it in the tlp settings

### Changing Domain
* have to change in immich's oauth settings and other settings
* have to change the OAuth applications with the new domain inside of authentik
* change cloudflare security rules: rate limiting rules and custom rules


### Someone going to another country
* Enable the country in the cloudflare security rules

