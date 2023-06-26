#!/bin/bash
source ~/.bashrc

is_empty() {
    local value=$1
    if [[ -z $value ]]; then
        return 0
    else
        return 1
    fi
}

read -p "Enter course name: " course
read -p "Enter first name: " first
read -p "Enter last name: " last
read -p "Enter username: " username
read -p "Enter email: " email

if is_empty "$first" || is_empty "$last" || is_empty "$username" || is_empty "$email" || is_empty "$course"; then
    echo "All fields are required. Please try again."
    exit 1
fi

courseData="{\"name\":\"$course\"}"
userData="{\"firstName\":\"$first\",\"lastName\":\"$last\",\"email\":\"$email\",\"userName\":\"$username\",\"role\":\"TEACHER\"}"

docker exec -it -e courseData=$courseData bubify-backend bash -c 'PROTOCOL=http;
if [[ $PRODUCTION = "true" ]]; then
  PROTOCOL="https";
fi; curl -k -X POST $PROTOCOL://localhost:8900/internal/course    -H "Content-Type: application/json"    -d "$courseData"'

docker exec -it -e userData=$userData bubify-backend bash -c 'PROTOCOL=http;
if [[ $PRODUCTION = "true" ]]; then
  PROTOCOL="https";
fi; curl -k -X POST $PROTOCOL://localhost:8900/internal/user    -H "Content-Type: application/json"    -d "$userData"'