if [ -z "$1" ]
  then
    echo "You have to supply your nextcloud url (like https://example.com/cron.php) as argument."
    exit 1
fi

while true; do
    curl $1
    sleep 5
done
