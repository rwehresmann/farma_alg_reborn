[![Build Status](https://travis-ci.org/rwehresmann/farma_alg_reborn.svg?branch=master)](https://travis-ci.org/rwehresmann/farma_alg_reborn) [![Code Climate](https://codeclimate.com/github/rwehresmann/farma_alg_reborn/badges/gpa.svg)](https://codeclimate.com/github/rwehresmann/farma_alg_reborn) [![Test Coverage](https://codeclimate.com/github/rwehresmann/farma_alg_reborn/badges/coverage.svg)](https://codeclimate.com/github/rwehresmann/farma_alg_reborn/coverage) [![Issue Count](https://codeclimate.com/github/rwehresmann/farma_alg_reborn/badges/issue_count.svg)](https://codeclimate.com/github/rwehresmann/farma_alg_reborn)

# Description

FARMA-ALG-REBORN it is an app for teaching algorithms, focused in error mediaton between teachers and students. 
We belive that the error is part of the learning process and should not be ignored. However, it is not unusual to see classes with a lot of students and only one teacher to handle with them. Specially when it envolves programming, thinking in the quantity of output errors generated in a class: it is impracticable for a teacher analise all these outputs.

So FARMA-ALG-REBORN it is a tool to automatically save and analise these outputs, calculating the error similarity, exposing to the teacher the error cases pedagogically more relevant to the class. 

## More about

Originally, [FARMA-ALG](https://github.com/alexkutzke/farma_alg) was developed by [Alex Kutzke](https://github.com/alexkutzke) in the Federal University of Paraná. FARMA-ALG-REBORN is a new implementation of the tool. This implementation intend to bring back the original features of the tool with upgrades, plus a module of gamification. 

The implementation is in course and constantly updated in this repository. 

**Please note:** 

> Deadlines issues allied to project scope changes made me ignore some good practices in code to have a finished version of the tool to be tested. This is a result of a search project, and should be evaluated for its purpose and functionality. A lot of code refactor can be done, and future steps of this work (after evaluate its practical result) include this. 

## Dependencies

This app is docker based. To avoid extra configurations, you should have `docker` and `docker-compose` installed in your machine.

If you don't want to install these softwares, you will be able to use this app installing:
  * Free Pascal Compiler;
  * ElasticSearch (>= 2.4.5);
  * PhantomJS (>= 1.9) - Used to run tests in development;
  * Postgres (>= 9.5);
  * Ruby (>= 2.3).

## Usage

Clone the repository: `git clone https://github.com/rwehresmann/farma_alg_reborn.git`. 

In the repository folder, run:
* `docker-compose  build`;
* `docker-compose  run --rm app rake db:create`;
* `docker-compose  run --rm app rake db:migrate`;
* `docker-compose  run --rm app rake db:seed` (only if you want to populate the db with sample data);
* `docker-compose  run --rm app rspec`

If rspec finish without errors, you're ready to start. Run `docker-compose up` and access `http://localhost:3000`.

## Whant to contribute?

Fork the project, create a branch and send a pull request!
