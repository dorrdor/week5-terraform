#!/bin/bash
git clone https://github.com/odedrafi/bootcamp-app.git

cd bootcamp-app

sudo apt update

curl -sL https://deb.nodesource.com/setup_14.x | sudo bash - #downloading nodejs libaries

cat /etc/apt/sources.list.d/nodesource.list

sudo apt -y install nodejs

npm install

npm audit fix

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client nodejs

wget --no-check-certificate https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem

npm install dotenv



sudo npm install pm2@latest -g # insatalling pm2 for the app to run automaticlly after machine reboot

cat <<EOF >.env
# Host configuration
PORT=8080	
HOST=0.0.0.0

# Postgres configuration
PGHOST=20.101.88.116
PGUSERNAME=dorrdor55
PGDATABASE=dorrdor55
PGPASSWORD=dorrdor55
PGPORT=5432

HOST_URL=http://20.101.88.116:8080
COOKIE_ENCRYPT_PWD=superAwesomePasswordStringThatIsAtLeast32CharactersLong!
NODE_ENV=development

# Okta configuration
OKTA_ORG_URL=https://dev-00420313.okta.com
OKTA_CLIENT_ID=0oa60sxd5iHgoPNCK5d7
OKTA_CLIENT_SECRET=kQZmw7l9ZDn1e7VF2zhPZrwyA5e3IDeXZDk_an3k

EOF

npm run initdb #initializing the data base

sudo pm2 start npm -- run dev
sudo pm2 save
sudo pm2 startup

 sudo pm2 start "npm run dev" #starting the app and saving it to pm2 watch list

 sudo pm2 save # saving pm2 watch list **important

 sudo pm2 startup

#update okta uris:
# curl --location --request PUT 'https://https://https://dev-00420313.okta.com//api/v1/apps/0oa60sxd5iHgoPNCK5d7' \
#     --header 'Accept: application/json' \
#     --header 'Content-Type: application/json' \
#     --header 'Authorization: SSWS ${OKTA_KEY}' \
#     --data-raw '{
#     "name": "oidc_client",
#     "label": "My Web App 1",
#     "credentials": {
#         "oauthClient": {
#             "autoKeyRotation": true,
#             "client_id": "${OKTA_CLIENT_ID}",
#             "token_endpoint_auth_method": "client_secret_basic"
#         }
#     },
#     "settings": {
#         "oauthClient": {
#             "redirect_uris": [
#                 "http://20.101.82.204:8080/authorization-code/callback"
#             ],
#             "post_logout_redirect_uris": [
#                 "http://20.101.82.204:8080/logout"
#             ],
#             "response_types": [
#                 "code"
#             ],
#             "application_type": "web",
#             "consent_method": "REQUIRED",
#             "issuer_mode": "DYNAMIC"
#         }
#     }
# }'