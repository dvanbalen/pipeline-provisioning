#!/bin/bash
#
####################### Help #################33
Help ()
{
	echo Usage:
	echo options:
	echo -t		Git personal access token -- base64 encoded
	echo -u		Username associated with git personal access token -- base64 encoded
	echo -s		Git OAuth application client secret -- base64 encoded
	echo -i		Git OAuth appliation client id
	echo -g		Branch of Git repository where gitops info is stored for communication between pipelines and ArgoCD -- base64 encoded
	echo
}

#
####################### Main #################33
while getopts ":ht:u:s:i:r:b:g:" option; do
	case $option in
		h)
			Help
			exit;;
		t)	Token=$OPTARG;;
		u)	User=$OPTARG;;
		s)	ClientSecret=$OPTARG;;
		i)	ClientId=$OPTARG;;
		r)	GitRepoUrl=$OPTARG;;
		b)	GitRepoBranch=$OPTARG;;
		g)	GitopsRepo=$OPTARG;;
		\?)
			echo "Invalid option. Use -h for help."
			exit;;
	esac
done

echo "Token = $Token";
echo "User = $User";
echo "ClientSecret = $ClientSecret";
echo "ClientId = $ClientId";
echo "GitRepoUrl = $GitRepoUrl";
echo "GitRepoBranch = $GitRepoBranch";
echo "GitopsRepo = $GitopsRepo";

# Add Git personal access token to pipeline secrets
if [[ ! -z "${Token}" ]]; then
	echo "replacing passwoord with ${Token}"
	tk=$Token yq -i '.data.password = env(tk) | .data.password style=""' base/pipelines/secrets.yaml
	tk=$Token yq -i '.data.password = env(tk) | .data.password style=""' base/gitops/secrets.yaml
fi

# Add Git username to pipeline secrets
if [[ ! -z "${User}" ]]; then
	echo "replacing username with ${User}"
	usr=$User yq -i '.data.username = env(usr) | .data.username style=""' base/pipelines/secrets.yaml
	usr=$User yq -i '.data.username = env(usr) | .data.username style=""' base/gitops/secrets.yaml
fi

# Add OAuth client secret to OAuth config
if [[ ! -z "${ClientSecret}" ]]; then
	echo "replacing client secret with ${ClientSecret}"
	cs=$ClientSecret yq -i '.data.clientSecret = env(cs) | .data.clientSecret style=""' base/auth/secrets.yaml
fi

# Add OAuth client id to OAuth config
if [[ ! -z "${ClientId}" ]]; then
	echo "replacing client id with ${ClientId}"
	ci=$ClientId yq -i '.spec.identityProviders[1].github.clientID = env(ci) | .spec.identityProviders[1].github.clientID style=""' base/auth/oauth.yaml
fi

#	echo -r		URL of Git repository to build
#	echo -b		Branch of Git repository to build
# Add Git repo URL to pipeline config
#if [[ ! -z "${GitRepoUrl}" ]]; then
#	echo "replacing git repo url with ${GitRepoUrl}"
#	gru=$GitRepoUrl yq -i '.data.username = env(gru) | .data.username style=""' base/pipelines/secrets.yaml
#fi

# Add Git repo branch to pipeline config
#if [[ ! -z "${GitRepoBranch}" ]]; then
#	echo "replacing git repo branch with ${GitRepoBranch}"
#	grb=$GitRepoBranch yq -i '.data.username = env(grb) | .data.username style=""' base/pipelines/secrets.yaml
#fi

# Add Gitops repo to argocd repository config
if [[ ! -z "${GitopsRepo}" ]]; then
	echo "replacing git repo branch with ${GitopsRepo}"
	gor=$GitopsRepo yq -i '.data.url = env(gor) | .data.url style=""' base/gitops/secrets.yaml
fi
