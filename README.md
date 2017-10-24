# Install 
oc create -f setup.json

# define the secret (for accessing bitbucket)
oc secrets new-sshauth bitbucket-secret --ssh-privatekey=$HOME/.ssh/id_rsa

