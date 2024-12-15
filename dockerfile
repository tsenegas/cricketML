# Use the official R base image
FROM r-base:4.3.0

# Install necessary packages
RUN R -e "install.packages(c('tidyverse', 'readr', 'tidymodels'))"

# Copy files into the container
WORKDIR /app
COPY ./model/simple_cricket_model.rds /app/
COPY ./data/processed_cricket_data.csv /app/
COPY predict_cricket.R /app/
COPY run_predictions.sh /app/

# Make the shell script executable
RUN chmod +x run_predictions.sh

# Set the default command to execute the shell script
CMD ["./run_predictions.sh"]
