# github-backup

* Create a new [personal access token](https://github.com/settings/tokens/new)
* Run `./github-backup.sh {target-folder} {username} {personal-access-token}`
* Or, run `docker run --rm -it -v {target-folder}:/backup choffmeister/github-backup {username} {personal-access-token}`
