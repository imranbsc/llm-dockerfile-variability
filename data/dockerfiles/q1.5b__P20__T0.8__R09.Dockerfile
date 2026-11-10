# Use an official Go runtime as a parent image
FROM golang:1.17

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -v -t

# Run the cron job
CMD ["cron", "-L", "/cronjobs", "-f", "/cronjobs/cron_job.sh"]
