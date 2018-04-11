REDIRECT_URI="urn:ietf:wg:oauth:2.0:oob" # HTTPサーバを起動しなくてもAuthorization_Codeを取得できる
SCOPE="https://picasaweb.google.com/data/" # Google Photos APIの代わりにPicasa APIを使う
echo "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=$CLIENT_ID&redirect_uri=$REDIRECT_URI&scope=$SCOPE&access_type=offline"
