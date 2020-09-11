#Google Cloud Fundamentals: Getting Started with Compute Engine

gcloud config set compute/zone us-central1-b

gcloud compute instances create "my-vm-1" \
--machine-type "n1-standard-1" \
--image-project "debian-cloud" \
--image "debian-9-stretch-v20190213" \
--subnet "default"

gcloud compute instances create "my-vm-2" \
--machine-type "n1-standard-1" \
--image-project "debian-cloud" \
--image "debian-9-stretch-v20190213" \
--subnet "default"

ping my-vm-1
ssh my-vm-1
sudo apt-get install nginx-light -y
curl http://localhost/
exit
curl http://my-vm-1/
