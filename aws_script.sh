#!/bin/bash
#author: Gustavo Marquez
docker run -d  --rm -it --name aws  -p 127.0.0.1:4566:4566   -p 127.0.0.1:4510-4559:4510-4559   -v /var/run/docker.sock:/var/run/docker.sock   localstack/localstack
if [[ -e $HOME/.aws/credentials ]]; then
	echo credentials file already exist
	echo "turning credentials into credentils_copy"
	mv $HOME/.aws/credentials $HOME/.aws/credentials_copy
	echo "now creating your temp credentials file" 
	cat <<EOF > $HOME/.aws/credentials
		[default]
		aws_access_key_id=test
		aws_secret_access_key=test
		[profile localstack]
		region=us-east-1
		output=json
		endpoint_url = http://localhost:4566
EOF

else
	echo "you have no aws credentials file"
	echo "creating one"
	echo "tmp credentials file created succesfully"
		cat <<EOF > $HOME/.aws/credentials
		[default]
		aws_access_key_id=test
		aws_secret_access_key=test
		[profile localstack]
		region=us-east-1
		output=json
		endpoint_url = http://localhost:4566
EOF
fi

if [[ -e $HOME/.aws/config ]]; then
	echo config file already exists
	echo "turning config into config_copy"
	mv $HOME/.aws/config $HOME/.aws/config_copy
	echo "now creating your temp config file" 
	cat <<EOF > $HOME/.aws/config
	[profile localstack]
	region=us-east-1
	output=json
	endpoint_url = http://localhost:4566
	[default]
	region = us-east-1
	output = json
	endpoint_url = http://localhost:4566
EOF
else
	echo "you have no aws config file"
	echo "creating one"
	echo "tmp config file created succesfully"
	cat <<EOF > $HOME/.aws/config
	[profile localstack]
	region=us-east-1
	output=json
	endpoint_url = http://localhost:4566
	[default]
	region = us-east-1
	output = json
	endpoint_url = http://localhost:4566
EOF
fi

echo "remember that your previous config and credentials files have a _copy sulfix now"
echo "to revert this config just run... "
echo "'rm $HOME/.aws/credentials && mv $HOME/.aws/credentials_copy $HOME/.aws/credentials'"
echo "'rm .aws/config && mv $HOME/.aws/config_copy $HOME/.aws/config'"

echo ' '
echo ' '
echo ' '
sleep 2

echo "creating 3 buckets to test the local endpoint"

buckets=("chimera" "genesis" "ego-death" "reverie")
sleep 3
for bucket in "${buckets[@]}";do
	aws s3api create-bucket --bucket $bucket > /dev/null
	echo "succesfully create $bucket"
done
echo "will output your current credentials..."
aws sts get-caller-identity
echo "#####################################"
echo "#####################################"
echo "run 'docker stop aws' to end your lab"
echo "#####################################"
echo "#####################################"
echo "happy codding :)"
echo "#####################################"
echo "#####################################"
