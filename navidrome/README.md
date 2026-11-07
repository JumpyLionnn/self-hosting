## Android Client
the used android client is `Wavio` 
The app is in the playstore and supports offline plays

to set it up download the app, and use the `basic_auth.sh` script to generate the custom header you have to pass in the app when logging in
```bash
sh ./basic_auth.sh <username> <application_password>
```
application password is an authentik application password assigned to each user


## TODO
configure `ExAuth.LogoutURL` to authentik url
Add https://github.com/NeptuneHub/AudioMuse-AI-NV-plugin plugin
in Authentik find a way to use always the local ip in the navidrome caddy provider config `Forward Auth (single application)` > `External Host`
