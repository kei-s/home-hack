ENDPOINT="https://picasaweb.google.com/data/feed/api/user/${USER_ID}/albumid/${ALBUM_ID}"
TYPE="image/jpeg"
LENGTH=`ls -l "${FILE}" | tail -n1 | sed -E 's/ +/ /g' | cut -d' ' -f5`

curl -XPOST -H "Content-Type:${TYPE}" -H "Content-Length:${LENGTH}" -H "Slug:${FILE}" "${ENDPOINT}?access_token=${ACCESS_TOKEN}" --data-binary "@${FILE}"

