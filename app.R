library(shiny)
ui <- fluidPage(
    title="HeartTracker",
    tabsetPanel(
        tabPanel("Home",
                 br(),
                 h2(style="text-align: center;",
                   "Welcome to HeartTracker!"),
                 br(),
                 h4(style="text-align: center;",
                    "This data product allows you to browse a large dataset of patients with and without heart disease, and to use a machine learning model to predict if you might or might not have heart disease based on the values in the dataset."),
                 h4(style="text-align: center;",
                   "Click on one of the tabs at the top to get started. Or if you'd like a more in-depth explanation, keep reading!"),
                 br(),
                 p(style="text-align: center;",
                    "I chose the topic of heart disease largely because I have a family history of heart disease, and thought that a tool to predict heart disease might be useful to me personally in the future, as well as to others with a similar family history."
                 ),
                 p(style="text-align: center;",
                    "This application has two components that allow you to delve into the data in two easy ways"
                 ),
                 p(style="text-align: center;",
                   "The first component is the data exploration tab. In this tab, you can view a scatter plot of various columns in the data set to see the relationship between them: the closer the data points come to making a straight line, the stronger their relationship. You can restrict the kind of data included in the scatter plot in order to get a better idea of specific factors that might be related to heart disease."
                 ),
                 p(style="text-align: center;",
                   "When exploring the data on my own, I was surprised to find that age and cholesterol are inversely related for patients with heart disease. That is, for patients with heart disease, cholesterol levels decrease with age. I had expected a positive correlation, and I'm not sure why the data show the opposite to be true. What kinds of interesting things can you find in your own exploration?"
                 ),
                 br(),
                 p(style="text-align: center;",
                    "The second component of this application is the machine learning tab. On this tab, you can use a machine learning model that was trained on this data set to predict whether or not you might have heart disease if you share certain values with these patients. I chose a logistic regression algorithm for the model because the key result (the presence or absence of heart disease) is either 0 or 1: in the data set, a patient either has heart disease, or they do not."
                 ),
                 p(style="text-align: center;",
                    "Many machine learning models split the available data into a training set and a test set: the model is trained on the training set, then checked for accuracy against the test set. When creating this application, I trained the model with 70% of the data, then checked it with the remaining 30%. The overall result had 90.18% accuracy: 107 true negatives, 141 true positives, 11 false negatives, and 16 false positives. The model used in this application was trained with all of the reference data, and is only tested with the user-provided input, so it should be even more accurate."
                 ),
                 p(style="text-align: center;",
                   "Happy exploring!"
                 ),
                 br(),
                 h4(style="text-align: center;",
                    "All data collected from ",
                    a(href="https://www.kaggle.com/fedesoriano/heart-failure-prediction", "Kaggle")
                 ),
        ),
        tabPanel("Data Exploration",
                 h4(style="text-align: center;",
                    "Use the tools below the plot to customize which data points are shown. See what kinds of trends you can find in the data!"
                 ),
                 fluidRow(
                     column(8, offset=2, plotOutput(outputId = "scatterplot"))
                 ),
                 wellPanel(
                     fluidRow(
                         column(3, 
                                selectInput("xaxis", "X-axis:", list("Age", "Resting Blood Pressure", "Cholesterol", "Max Heart Rate"))
                         ),
                         column(3,
                                selectInput("yaxis", "Y-axis:", list("Age", "Resting Blood Pressure", "Cholesterol", "Max Heart Rate"), selected="Resting Blood Pressure"),
                         ),
                         column(2,
                                checkboxInput("regression", "Show linear regression", value=FALSE),
                         ),
                         column(2,
                                checkboxInput("xfit", "Start X-axis at 0", value=FALSE),
                         ),
                         column(2,
                                checkboxInput("yfit", "Start Y-axis at 0", value=FALSE),
                         )
                     ),
                     fluidRow(
                         column(3,
                                radioButtons("sex", "Sex",
                                             choices=list("All"=1, "Female"=2, "Male"=3),
                                             selected=1),
                         ),
                         column(4,
                                checkboxGroupInput("restingecg", "Include patients whose resting electrocardiogram values are:", 
                                                   choices=list("Normal"=1, "ST"=2, "Left Ventricular Hypertrophy (LVH)"=3),
                                                   selected=list(1,2,3)),
                         ),
                         column(3,
                                checkboxGroupInput("stslope", "Include patients whose ST Slopes are:", 
                                                   choices=list("Flat"=1, "Up"=2, "Down"=3),
                                                   selected=list(1,2,3)),
                         ),
                         column(2,
                                checkboxInput("fastingbs", "Include only patients whose blood sugar readings were taken while fasting", value=FALSE),
                         )
                     ),
                     fluidRow(
                         column(3,
                                radioButtons("exerciseangina", "Exercise Angina (EA)",
                                             choices=list("Include all"=1, "Include only patients with EA"=2, "Include only patients without EA"=3),
                                             selected=1),
                         ),
                         column(4,
                                checkboxGroupInput("chestpain", "Include patients with chest pain types that are:", 
                                                   choices=list("No chest pain"=1, "Typical Angina"=2, "Atypical Angina"=3, "Non-angina pain"=4),
                                                   selected=list(1,2,3,4)),
                         ),
                         column(4,
                                sliderInput("oldpeak", "Include only oldpeak values in the range:",
                                            min=-10, max=10, value=c(-10, 10), step=0.5)
                         )
                     )    
            )
        ),
        tabPanel("Machine Learning",
                 h4(style="text-align: center;",
                    "Use the input boxes below to enter a patient's personal data, then click the \"Submit\" button to have the machine learning model analyze it"
                 ),
                 br(),
                 fluidRow(
                    column(2,
                           numericInput("mlage", "How old are you?", min=1, max=120, value=50)
                    ),
                    column(2,
                           radioButtons("mlsex", "What is your sex?", choices=list("Female"="F", "Male"="M"))
                    ),
                    column(2,
                           numericInput("mlmaxhr", "What is your max heart rate?", min=50, max=250, value=120)
                    ),
                    column(2,
                           numericInput("mlrestingbp", "What is your resting blood pressure?", min=50, max=250, value=100)
                    ),
                    column(4,
                           radioButtons("mlchestpaintype", "What kind of chest pain, if any, do you have?", 
                                        choices=list("No chest pain"="ASY", "Typical Angina"="TA", "Atypical Angina"="ATA", "Non-angina pain"="NAP"))
                    )
                 ),
                 fluidRow(
                     column(2,
                            radioButtons("mlstslope", "What is your ST Slope?", 
                                         choices=list("Flat", "Up", "Down"))
                     ),
                     column(2,
                            numericInput("mloldpeak", "What is your oldpeak? *", min=-1, max=10, step=0.1, value=2.0)
                     ),
                     column(2,
                            numericInput("mlcholesterol", "What is your cholesterol level?", min=50, max=650, value=300)
                     ),
                     column(2,
                            radioButtons("mlexerciseangina", "Do you have Excersise Angina?", 
                                         choices=list("Yes"="Y", "No"="N"))
                     ),
                     column(4,
                            radioButtons("mlrestingecg", "What is your resting electrocardiogram value?", 
                                         choices=list("Normal", "ST", "Left Ventricular Hypertrophy (LVH)"))
                     )
                 ),
                 fluidRow(style="text-align: center;",
                          column(8, offset=2, "* oldpeak represents ST depression induced by exercise relative to rest")
                 ),
                 br(),
                 fluidRow(style="text-align: center;",
                     column(2, offset=5, actionButton(inputId="submit", "Submit"))
                 ),
                 br(),
                 fluidRow(style="text-align: center;",
                     column(8, offset=2, textOutput(outputId="results"))
                 )
        )
    )
)

server <- function(input, output) {
    library(tidyverse)
    library(ggplot2)
    library(dplyr)
    library(caTools)
    library(caret)
    
    raw <- read.csv("heart.csv")
    
    training <- raw
    logistic <- glm(HeartDisease ~ ., data = training, family = "binomial")
    
    output$scatterplot <- renderPlot({
        data <- tibble(raw) %>%
            mutate(HeartDisease = ifelse(HeartDisease == 0, "No", "Yes"))
        
        if (input$xaxis == "Age") {
            data <- data %>% mutate(x = Age)
        } else if (input$xaxis == "Resting Blood Pressure") {
            data <- data %>% mutate(x = RestingBP)
        } else if (input$xaxis == "Cholesterol") {
            data <- data %>% mutate(x = Cholesterol)
        } else if (input$xaxis == "Max Heart Rate") {
            data <- data %>% mutate(x = MaxHR)
        }
        data <- data %>% filter(x != 0)
        
        if (input$yaxis == "Age") {
            data <- data %>% mutate(y = Age)
        } else if (input$yaxis == "Resting Blood Pressure") {
            data <- data %>% mutate(y = RestingBP)
        } else if (input$yaxis == "Cholesterol") {
            data <- data %>% mutate(y = Cholesterol)
        } else if (input$yaxis == "Max Heart Rate") {
            data <- data %>% mutate(y = MaxHR)
        }
        data <- data %>% filter(y != 0)
        
        if (input$sex == 2) {
            data <- data %>% filter(Sex == "F")
        } else if (input$sex == 3) {
            data <- data %>% filter(Sex == "M")
        }
        
        if (input$fastingbs) {
            data <- data %>% filter(FastingBS == 1)
        }
        
        if (!1 %in% input$restingecg) {
            data <- data %>% filter(RestingECG != "Normal")
        }
        if (!2 %in% input$restingecg) {
            data <- data %>% filter(RestingECG != "ST")
        }
        if (!3 %in% input$restingecg) {
            data <- data %>% filter(RestingECG != "LVH")
        }
        
        if (input$exerciseangina == 2) {
            data <- data %>% filter(ExerciseAngina == "Y")
        } else if (input$exerciseangina == 3) {
            data <- data %>% filter(ExerciseAngina == "N")
        }
        
        if (!1 %in% input$stslope) {
            data <- data %>% filter(ST_Slope != "Flat")
        }
        if (!2 %in% input$stslope) {
            data <- data %>% filter(ST_Slope != "Up")
        }
        if (!3 %in% input$stslope) {
            data <- data %>% filter(ST_Slope != "Down")
        }
        
        if (!1 %in% input$chestpain) {
            data <- data %>% filter(ChestPainType != "ASY")
        }
        if (!2 %in% input$chestpain) {
            data <- data %>% filter(ChestPainType != "TA")
        }
        if (!3 %in% input$chestpain) {
            data <- data %>% filter(ChestPainType != "ATA")
        }
        if (!4 %in% input$chestpain) {
            data <- data %>% filter(ChestPainType != "NAP")
        }
        
        data <- data %>% filter(Oldpeak >= input$oldpeak[1])
        data <- data %>% filter(Oldpeak <= input$oldpeak[2])
        
        xfit <- if (input$xfit) 0 else min(data$x)
        yfit <- if (input$yfit) 0 else min(data$y)
        regression <- if (input$regression) "lm" else ""
        
        ggplot(data, aes(x=x, y=y, color=HeartDisease)) +
            geom_point() +
            xlim(xfit, NA) +
            ylim(yfit, NA) +
            labs(x = input$xaxis, y=input$yaxis) +
            geom_smooth(formula=y ~ x, method=regression, se=FALSE)
    })
    
    results <- eventReactive(input$submit, {
        userData <- data.frame(
            Age=input$mlage,
            Sex=input$mlsex,
            ChestPainType=input$mlchestpaintype,
            RestingBP=input$mlrestingbp,
            Cholesterol=input$mlcholesterol,
            FastingBS=0,
            RestingECG=input$mlrestingecg,
            MaxHR=input$mlmaxhr,
            ExerciseAngina=input$mlexerciseangina,
            Oldpeak=input$mloldpeak,
            ST_Slope=input$mlstslope,
            HeartDisease=0
        )
        
        probs <- predict(logistic, newdata = userData, type = "response")
        pred <- ifelse(probs > 0.5, 1, 0)
    })
    
    output$results <- renderText({
        pred <- results()
        
        if (pred == 0) {
            print("Our data indicates that, given the values you have entered, you do not have heart disease.")
        } else if (pred == 1) {
            print("The model predicts that you have heart disease. You should visit your primary care provider to confirm")
        } else {
            print("Something went wrong")
        }
    })
}

shinyApp(ui = ui, server = server)
