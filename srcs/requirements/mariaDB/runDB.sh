# Build the Docker image
docker build -t inceptionDB .

# Run the Docker container
docker run --env-file ../../.env -p 3306:3306 inceptionDB