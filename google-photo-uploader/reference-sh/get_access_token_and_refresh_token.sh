REDIRECT_URI="urn:ietf:wg:oauth:2.0:oob" # HTTPサーバを起動しなくてもAuthorization_Codeを取得できる

curl --data "code=${AUTHORIZATION_CODE}" --data "client_id=${CLIENT_ID}" --data "client_secret=${CLIENT_SECRET}" --data "redirect_uri=${REDIRECT_URI}" --data "grant_type=authorization_code" --data "access_type=offline" https://www.googleapis.com/oauth2/v4/token
