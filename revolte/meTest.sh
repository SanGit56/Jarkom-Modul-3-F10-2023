curl -X POST -H "Content-Type: application/json" -d @account.json http://192.226.2.2:81/api/auth/login > token.txt
token=$(cat token.txt | jq -r '.token') 
ab -n 100 -c 10 -H "Authorization: Bearer $token" http://192.226.2.2:81/api/me
