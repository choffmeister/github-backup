#!/bin/bash -e

TARGET_FOLDER="$1"
USER="$2"
ACCESS_TOKEN="$3"

TEMP_FOLDER="${TARGET_FOLDER}/temp"
BACKUP_FILE="./github_${USER}_$(date +"%Y%m%d")_$(date +"%H%M%S").tar.gz"
API_URL="https://api.github.com/user/repos?affiliation=owner"

echo "Cloning repositories..."
rm -rf "${TEMP_FOLDER}" && mkdir "${TEMP_FOLDER}" && cd "${TEMP_FOLDER}"
for PAGE in {1..1000}; do
    REPO_URLS=$(curl -u "${USER}:${ACCESS_TOKEN}" -s "${API_URL}&page=${PAGE}&per_page=100" | grep -Eo '"clone_url": "[^"]+"' | awk '{print $2}' | sed 's/"//g')
    if [[ -z ${REPO_URLS} ]]; then break; fi
    for REPO_URL in $REPO_URLS; do
        echo "${REPO_URL}"
        AUTH_REPO_URL=$(echo "${REPO_URL}" | sed "s#https://github.com#https://${USER}:${ACCESS_TOKEN}@github.com#")
        git clone "${AUTH_REPO_URL}" 2>/dev/null
    done
done

echo "Generating archive..."
echo "${BACKUP_FILE}"
cd "${TARGET_FOLDER}"
tar -zcf "${BACKUP_FILE}" --directory=temp .
rm -rf "${TEMP_FOLDER}"

echo "Remove backups older than 30 days..."
cd "${TARGET_FOLDER}"
OLD_BACKUPS=$(find . -name "*.tar.gz" -type f -mtime +30)
for OLD_BACKUP in $OLD_BACKUPS; do
    echo "${OLD_BACKUP}"
    rm "${OLD_BACKUP}"
done
