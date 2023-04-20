
# Our Repositories

<https://github.com/SteveMaglio/DawgPatrolBoilerplate>
<https://github.com/SteveMaglio/dawgpatrol-appsmith>

# Our Video Link

<https://www.youtube.com/watch?v=IJkhdbNYCac>

# Project Overview

Our project is a essentially a dashboard for the Marino Fitness Center on campus. For both students and employees, navigating Marino is a time-consuming and frustrating effort that results in a lot of standing around and waiting. Machines have lines can last upwards of an hour, and some people spend more time waiting than working out.

Our platform is designed to solve this issue, allowing students to publish wait times for certain machines, and also displays which machines have the lowest wait time. This will help gym-goers navigate to those machines, and change their split according to the path of least resistance. DawgPatrol also displays metrics for locker room capacity, towel availability, and class attendance. This helps the students better plan their gymgoing experience and helps them spend their time more effectively while at the gym.

For managers, they can select which of the many Sections an employee can work in during their shift, manage schedules, and select songs to be played over the sound system for the gym atendees to listen to. If a new machine is purchased, or an existing one gets damaged, managers can use our platform to represent that in the SQL database accordingly.

# Docker/Startup Info

1. Clone our repository from our public GitHub repo.
   1. use `git clone git@github.com:SteveMaglio/DawgPatrolBoilerplate.git`
2. cd into the reposity using the terminal/Bash.
3. run the command: `docker compose up`
4. To access our Appsmith page once all the containers have spun up, enter the url <localhost:8080> into your web browser.
5. Press the preview button in the top right to see the production version of our platform!
