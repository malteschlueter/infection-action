#!/bin/bash
set -e
github_action_path=$(dirname "$0")
docker_tag=$(cat ./docker_tag)
echo "Docker tag: $docker_tag" >> output.log 2>&1

phar_url="https://phar.phpunit.de/phpunit"
if [ "$ACTION_PHPUNIT_VERSION" != "latest" ]
then
	phar_url="${phar_url}-${ACTION_PHPUNIT_VERSION}"
fi
phar_url="${phar_url}.phar"
curl --silent -H "User-agent: cURL (https://github.com/php-actions)" -L "$phar_url" > "${github_action_path}/phpunit.phar"
chmod +x "${github_action_path}/phpunit.phar"

phar_url="https://github.com/infection/infection/releases/download/0.25.3/"
#if [ "$ACTION_VERSION" != "latest" ]
#then
#	phar_url="${phar_url}-${ACTION_VERSION}"
#fi
phar_url="${phar_url}/infection.phar"
curl --silent -L "$phar_url" > "${github_action_path}/infection.phar"
chmod +x "${github_action_path}/infection.phar"

command_string=("infection")

if [ -n "$ACTION_CONFIGURATION" ]
then
	command_string+=(--configuration="$ACTION_CONFIGURATION")
fi

if [ -n "$ACTION_TEST_FRAMEWORK_OPTIONS" ]
then
	command_string+=(--test-framework-options="$ACTION_TEST_FRAMEWORK_OPTIONS")
fi

if [ -n "$ACTION_ARGS" ]
then
	command_string+=($ACTION_ARGS)
fi

command_string+=(--logger-github)

echo "Command: " "${command_string[@]}" >> output.log 2>&1
docker run --rm \
	--volume "${github_action_path}/infection.phar":/usr/local/bin/infection \
	--volume "${github_action_path}/phpunit.phar":/usr/local/bin/phpunit \
	--volume "${GITHUB_WORKSPACE}":/app \
	--workdir /app \
	--network host \
	--env-file <( env| cut -f1 -d= ) \
	${docker_tag} "${command_string[@]}"
