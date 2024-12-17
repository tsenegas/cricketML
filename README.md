# cricketML

# Executive Summary

This project showcases my technical and analytical skills through the completion of a comprehensive data science assessment provided by Teamworks / Zelus Analytics. The assessment focuses on modeling, infrastructure design, and deployment, using ball-by-ball data from professional cricket matches.

I truly enjoyed working on this exercise. As I am not used to deploying models for local use, I found it very interesting to rediscover some functionalities. My usual experience involves deploying models and web applications (primarily in R Shiny) via Docker, with API calls directly to servers.

I am very excited about the possibility of continuing the recruitment process with Teamworks/Zelus Analytics, if the opportunity arises. I would also like to highlight that I have a strong expertise in R Shiny. From posts I saw from Christopher Pickard, I understand that the Soccer team is looking for engineers and data scientists working in R/R Shiny, which are my primary areas of expertise. That said, I am open to joining any team within Teamworks/Zelus Analytics.

## Key Objectives

1.  Infrastructure Design: Develop a scalable architecture for deploying a predictive model that processes high-frequency temporal data at scale.
2.  Data Preparation and Modeling: Create a dataset from match data and develop a basic predictive model for expected runs per over in cricket matches.
3.  Deployment and Testing: Package the model in a cross-platform, reproducible environment using Docker, and implement unit testing for robustness.

## Highlights

-   **Scalable Architecture**: Designed a cloud-based pipeline to process \~1 GB of high-frame-rate data per game, addressing storage, computation, and prediction delivery at scale.
-   **Predictive Modeling**: Built a streamlined model pipeline using run and wicket data to predict performance metrics, emphasizing reproducibility and interpretability.
-   **Reproducible Deployment**: Leveraged containerization to ensure cross-platform usability, along with CLI tools for local execution.
-   **Quality Assurance**: Developed unit tests to validate model training and prediction, ensuring reliability under varied conditions.

This work demonstrates my ability to design end-to-end data solutions, leveraging my expertise in modeling, scalable system architecture, and reproducible deployment. The methodology and results are detailed throughout this site to provide transparency and insight into my problem-solving approach

# Part I: Infrastructure

In the first part, we present and describe the IT Infrastructure to deploy and maintining a Machine Learning Model that predicts frame-level play value into a cloud environment.

For a detailed view of the architecture with listed services associated, check the following page:

-   [IT Architecture](https://tsenegas.github.io/cricketML/architecture.html)

# Part II: Model Pipelines and Deployment

## Question 2

I rate my knowledge of cricket at 1. I basicly never seen or read anything related to cricket.

## Question 3.a

Here are my intermediate data after first cleaning :

-   [Intermediate data, in csv](https://docs.google.com/spreadsheets/d/1DeIHBTV5s94A6IjrO8mPDSUp21-Mqs5eyOJ5E6iYWzw/edit?usp=sharing){target="_blank"}

You can show in details my code and explanation to went from raw data to that dataset [here](https://tsenegas.github.io/cricketML/data_processing.html)

You can also access the RScript directly on my GitHub repo - [data_processing.R](https://github.com/tsenegas/cricketML/blob/main/scripts/data_processing.R){target="_blank"}

## Question 3.b

We've created a very basic and simple ML model to predict an average team's expected runs per over. Find the code and explanation [here](https://tsenegas.github.io/cricketML/data_modelling.html)

You can also access the RScript directly on my GitHub repo - [data_modelling.R](https://github.com/tsenegas/cricketML/blob/main/scripts/data_modelling.R){target="_blank"}

## Question 4

You can download docker's image [here](https://drive.google.com/file/d/1aO6sgYZeBRZhDNS_JWJbTGVjdkE4dAZJ/view?usp=sharing){target="_blank"}

Once downloaded, upload the image on your computer and run it - there are some pre requis : - You need to have docker.desktop (For Windows or Mac depending of your OS / Get Docker Engine on Linux) - On your cmd invit, navigate to the folder where you download the docker image and type : docker load -i cricket_model.tar - from your cmd invit, type docker run --rm -it cricket_model (you need to put -it, as you will need to select options)

Running the docker's image, you will have two options :
- 1. Run the demo
- 2. Run on your datas

For more explanation to see the process to create the image and to run it, you can take a look [there](https://tsenegas.github.io/cricketML/deployment.html)

## Question 5

I built some unit tests for my prediction and training code. Check them [here](https://tsenegas.github.io/cricketML/unit_test.html)