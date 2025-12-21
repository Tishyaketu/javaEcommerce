#!/bin/bash

# Keycloak Configuration
KEYCLOAK_URL="http://localhost:8080"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"
REALM_NAME="spring-boot-microservices-realm"
CLIENT_ID="spring-cloud-client"

echo "Get Admin Token..."
TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=$ADMIN_USER" \
    -d "password=$ADMIN_PASSWORD" \
    -d "grant_type=password" \
    -d "client_id=admin-cli" | jq -r .access_token)

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo "Failed to get token. Check Keycloak status."
    exit 1
fi
echo "Token received."

echo "Create Realm $REALM_NAME..."
curl -s -X POST "$KEYCLOAK_URL/admin/realms" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"realm\": \"$REALM_NAME\", \"enabled\": true}"

echo "Create Client $CLIENT_ID..."
curl -s -X POST "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"clientId\": \"$CLIENT_ID\",
        \"enabled\": true,
        \"publicClient\": false,
        \"serviceAccountsEnabled\": true,
        \"authorizationServicesEnabled\": true,
        \"standardFlowEnabled\": true,
        \"implicitFlowEnabled\": false,
        \"directAccessGrantsEnabled\": true,
        \"redirectUris\": [\"http://localhost:8181/login/oauth2/code/keycloak\"]
    }"

echo "Get Client UUID..."
CLIENT_UUID=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients?clientId=$CLIENT_ID" \
    -H "Authorization: Bearer $TOKEN" | jq -r .[0].id)

if [ "$CLIENT_UUID" == "null" ] || [ -z "$CLIENT_UUID" ]; then
    echo "Failed to get Client UUID."
    exit 1
fi
echo "Client UUID: $CLIENT_UUID"

echo "Generate Client Secret..."
CLIENT_SECRET=$(curl -s -X POST "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients/$CLIENT_UUID/client-secret" \
    -H "Authorization: Bearer $TOKEN" | jq -r .value)

echo "Success! Realm and Client configured."
echo "Client ID: $CLIENT_ID"
echo "Client Secret: $CLIENT_SECRET"

# Save secret to a file if needed
echo "$CLIENT_SECRET" > client_secret.txt
