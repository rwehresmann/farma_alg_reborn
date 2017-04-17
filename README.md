# Description

FARMA-ALG it is an app for teaching algorithms, focused in error mediaton between teachers and students. 
We belive that the error is part of the learning process and should not be ignored. However, it is not unusual to see classes with a lot of students and only one teacher to handle with them. Specially when it envolves programming, think in the quantity of output errors generated in a class: it is impracticable to a teacher analise all these outputs.

So FARMA-ALG it is a tool to automatically save and analise these outputs, calculating the error similarity, exposing to the teacher the error cases pedagogically more relevant to the class. 

## More about

Originally, [FARMA-ALG](https://github.com/alexkutzke/farma_alg) was developed by [Alex Kutzke](https://github.com/alexkutzke) in the Federal University of Paraná. FARMA-ALG-REBORN is a new implementation of the tool. This implementation intend to bring back the original features of the tool with upgrades, plus a module of gamification. 

The implementation is in course and constanttly updated in this repository.

## Dependencies

* [Free Pascal Compiler](http://www.freepascal.org/)
* [ElasticSearch](https://www.elastic.co/products/elasticsearch)
* [PhantomJS](http://phantomjs.org/)

## Usage

* Install dependencies;
* Clone the repository;
* Run `bundle install`;
* Run `rake db:create` and `rake db:migrate`;
* If you want populate the database with sample data, run `rake db:seed`;
* Run `rspec`. If none test fails, you are ready to start!

## Whant to contribute?

Fork the project, create a branch and send a pull request!
