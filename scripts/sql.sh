#Google Cloud Fundamentals: Getting Started with Cloud Storage and Cloud SQL

cat <<EOF > script.sh
#! /bin/bash
apt-get update
apt-get install apache2 php php-mysql -y
service apache2 restart
EOF

gcloud config set compute/zone us-central1-b

gcloud compute instances create "bloghost" \
--machine-type "n1-standard-1" \
--image-project "debian-cloud" \
--image "debian-9-stretch-v20190213" \
--subnet "default" \
--metadata-from-file \ startup-script=script.sh

export LOCATION=US

gsutil mb -l $LOCATION gs://$PROJECT_ID
gsutil cp gs://cloud-training/gcpfci/my-excellent-blog.png my-excellent-blog.png
gsutil cp my-excellent-blog.png gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png

gcloud sql databases create  blog-db --instance blog-db
gcloud sql users set-password root --instance blog-db \ --password password --network

gcloud sql users create blogdbuser --instance=blog-db \ --password=password

gcloud compute ssh USER@$INSTANCE_IP

cat <<EOF >  index.php
<html>
<head><title>Welcome to my excellent blog</title></head>
<body>
<h1>Welcome to my excellent blog</h1>
<?php
 $dbserver = "CLOUDSQLIP";
$dbuser = "blogdbuser";
$dbpassword = "DBPASSWORD";
// In a production blog, we would not store the MySQL
// password in the document root. Instead, we would store it in a
// configuration file elsewhere on the web server VM instance.

$conn = new mysqli($dbserver, $dbuser, $dbpassword);

if (mysqli_connect_error()) {
        echo ("Database connection failed: " . mysqli_connect_error());
} else {
        echo ("Database connection succeeded.");
}
?>
</body></html>
EOF

sudo service apache2 restart
open 35.192.208.2/index.php
