
## Restoring
Install docker, docker compose and make sure you can run it without elevated root privilages
Install borg and run the restore command in each sub directory
LIMITATION: TODO: you must clone the repo into the user's home directory
TODO: Remove dependency of the app .env from the restore and backup scripts


## Notes
### wake on lan
make sure to enable it in the tlp settings

### Changing Domain
* have to change in immich's oauth settings and other settings
* have to change the OAuth applications with the new domain inside of authentik
* change cloudflare security rules: rate limiting rules and custom rules


### Someone going to another country
* Enable the country in the cloudflare security rules

