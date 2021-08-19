
# Example of Usage:
# ./deploy-sample-app.sh

oc new-project stackrox-sample-app

oc run shell --labels=app=shellshock,team=test-team \
  --image=vulnerables/cve-2014-6271 -n stackrox-sample-app

oc run samba --labels=app=rce \
  --image=vulnerables/cve-2017-7494 -n stackrox-sample-app