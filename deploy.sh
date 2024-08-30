cd /var/www/k9-random-data-api || git clone https://github.com/nmmanas/random_k9_data.git /var/www/k9-random-data-api
cd /var/www/k9-random-data-api

# Reset any local changes to the configuration files
git reset --hard HEAD

# Pull the latest changes from the repository
git pull origin main

# Check if the local NGINX container is running
if docker ps | grep local_nginx; then
    echo "Local NGINX is running. Proceeding with update."
else
    echo "Local NGINX is not running. Setting up for the first time."
    # Start local NGINX with one of the Flask app services
    docker compose up -d --build k9_random_data_api_blue local_nginx
    # Update local NGINX to use blue initially
    sed -i 's/server k9_random_data_api_green:5000;/server k9_random_data_api_green:5000 down;/' local_nginx.conf
    docker compose exec local_nginx nginx -s reload
    exit 0
fi

# Check which service is currently running
if docker ps | grep k9_random_data_api_blue; then

    # Update green and start it
    docker compose up --build -d k9_random_data_api_green

    # Health check for green
    until docker exec k9-random-data-api-local_nginx-1 curl -s http://k9_random_data_api_green:5000/health | grep "OK"; do
        echo "Waiting for green to be ready..."
        sleep 5
    done

    # Update local NGINX to use green
    sed -i 's/server k9_random_data_api_blue:5000;/server k9_random_data_api_blue:5000 down;/' local_nginx.conf
    
    # Reload local NGINX
    docker compose exec local_nginx nginx -s reload

    # Stop blue
    docker compose stop k9_random_data_api_blue

else

    # Update blue and start it
    docker compose up --build -d k9_random_data_api_blue

    # Health check for blue
    until docker exec k9-random-data-api-local_nginx-1 curl -s http://k9_random_data_api_blue:5000/health | grep "OK"; do
        echo "Waiting for blue to be ready..."
        sleep 5
    done

    # Update local NGINX to use blue
    sed -i 's/server k9_random_data_api_green:5000;/server k9_random_data_api_green:5000 down;/' local_nginx.conf
    
    # Reload local NGINX
    docker compose exec local_nginx nginx -s reload

    # Stop green
    docker compose stop k9_random_data_api_green
fi

# Optionally: Clean up unused images and containers
docker system prune -f