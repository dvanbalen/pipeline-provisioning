# Spruce Provisioning via Kustomize

## Installation Procedure:

1. Log into OpenShift cluster
2. git clone https://github.com/RH-SPRUCE-TEAM/spruce-provisioning.git
3. cd spruce-provisioning
4. Run the configuration script, with one or more of the optional parameters. Keep in mind that some parameters need to be base64 encoded (run the script with -h to see a description of each option, and whether it needs to be encoded).
5. ./configure.sh -t "\<git-personal-access-token\>" -u "\<git-username\>" -g "\<devops-github-repo-url\>" -s "\<git-oauth-client-secret\>" -i "\<git-oauth-client-id\>"
6. oc apply -k pre-requisites
7. Wait until all operators under Installed Operators in the OpenShift console are showing a status of "Succeeded"
8. oc apply -k base

## If you are configuring GitHub OAuth on the cluster

1. Go to Org in GitHub
2. Click Settings
3. Click Developer settings
4. Click OAuth Apps
5. Click New Org OAuth App button
6. Name the new app "va-spruce-<OCPClusterID>
7. Paste the main cluster URL under Homepage URL
8. Set the Authorization callback URL to "https://oauth-openshift.<your-cluster-url>/oauth2callback/va-spruce-team/"
9. Click the Register application button
10. Copy the Client ID and add it to the spec/identityProviders/github/clientID field in the base/auth/oauth.yaml file
11. Click the Generate a new client secret button
12. Copy the client secret and add it to the base/auth/secrets.yaml file
13. Click the Update application button

## Setting up a Webhood for the Dev Pipeline

1. View Routes for the spruce-pipelines namespace and copy the URL for the el-eventlistener-ui Route
2. Navigate to the Git repository that you would like to trigger the build
3. Click on Settings
4. Click on Webhooks
5. click on the Add webhook button
6. Paste the eventlistener URL that was copied in step 1 under Payload URL
7. Make sure the Content type is set to application/json
8. Click the Add webhook button
9. If there's a need to see the payload that was sent to the eventlistener URL, click the Edit button for the webhook, then the Recent Deliveries tab
