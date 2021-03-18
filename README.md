# R-Studio / Seurat Docker Environment
---

This project is intended to allow users of R-Studio and Seurat to establish a reproducible environment for data analysis.  

The general workflow is :

1. Run a docker container with R-Studio and Seurat 
2. Create an analysis project structure and verison control repository
3. Create analysis scripts, functions, reports, etc. adding additional packages as necessary
4. Capture the R environment in a `renv.lock` file
5. Commit analysis to version control at appropriate time points

### 1. Run a docker container with R-Studio and Seurat 

To run the docker container do the following in the host machine (e.g. Mac OS) terminal : 
 
 * Clone this repo (only need to do this the first time)
 	*  e.g. `git clone https://github.com/aforsythe/r-seurat`
 * Run `docker-compose` for the version of Seurat you'd like to use.
 	*  e.g. `cd dev && docker-compose up -d`
 * After the container has finished building, go to `http://localhost:8787` in your browser
 	*  Building the container for the first time might take as long as 15 mins or so.  Subsequent container launches will be much quicker, if not immediate. 	

### 2. Create an analysis project structure and verison control repository

To create an analysis project, type the following in the R console:

   *  `project_template('my_analysis')` where `my_analysis` is a name of your choosing for the project.

### 3. Create analysis scripts, functions, reports, etc. adding additional packages as necessary

All data in the container should be saved in the project directory (e.g. `~/r_data/my_analysis`)  The data will be available locally in `~/r_data/my_analysis`.  Save all files when stopping the container because container data is ephemeral.

   * Create scripts in R and save to `./my_analysis/scripts`
   * Reusable functions should be saved to `./my_analysis/scripts/functions/`
   * Original data should be saved to `./my_analysis/data/original`
   * Cleaned data should be saved, using a script, to `./my_analysis/data/clean`
   * Any resulting data saved from a script should be saved to `./my_analysis/results/data`
   * Any resulting figures saved from a script should be saved to `./my_analysis/results/figures`
   * Rmarkdown reports should be saved to `./my_analysis/rmarkdown/reports`
   * Rmarkdown presentations should be saved to `./my_analysis/rmarkdown/presentations`

### 4. Capture the R environment in a `renv.lock` file

When you've got an analysis that's working, make sure all scripts are saved then in the R console type:

  * `renv::snapshot()`


### 5. Commit analysis to version control at appropriate time points

Commit the files to a git repo by typing the following in the terminal inside the container (e.g. using the terminal tab in RStudio)

* `cd ~/r_data/my_analysis && git add .`
* `git commit -m 'my first commit'` 
  *  If prompted, type:
  `git config --global user.email "you@example.com"` and
  `git config --global user.name "Your Name"` to setup git using your username and full name.
* Replace `my first commit` with an appropriate message describing what's changed in the code since the last commit.
 

When you are done with the project for a while, or want to start a new project, delete the Docker container by typing the following the in the Host terminal :

* `docker stop $(docker ps -a -q)`
* `docker rm $(docker ps -a -q)`

You can also use the stop and trash icons in the docker desktop gui.

To revisit a project: 

* do step #1 (e.g. `docker-compose up -d` and visit `https://localhost:8787`)
* In RStudio go to `File -> Open Project` and navigate to the project you'd like to work with opening the `.Rproj` file (e.g. `my_analysis.Rproj`
 



