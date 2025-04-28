#!/bin/bash
#author: Gustavo Marquez
if [[ $(docker -v) ]]; then
        echo "docker CLI detected, proceeding..."
	docker run -d  --rm -it --name aws  -p 127.0.0.1:4566:4566   -p 127.0.0.1:4510-4559:4510-4559   -v /var/run/docker.sock:/var/run/docker.sock   localstack/localstack
else
	echo 'No docker CLI detected'
	echo 'install it and run the script again'
	exit 1
fi
if [[ -e $HOME/.aws/credentials ]]; then
	echo credentials file already exist
	echo "turning credentials into credentils_copy"
	mv $HOME/.aws/credentials $HOME/.aws/credentials_copy
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
	mv $HOME/.aws/config $HOME/.aws/config_copy
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

echo "creating 4 buckets to test the local endpoint"

buckets=("chimera" "genesis" "ego-death" "reverie")
sleep 3
for bucket in "${buckets[@]}";do
	aws s3api create-bucket --bucket $bucket > /dev/null
	echo "succesfully created bucket named: $bucket"
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
