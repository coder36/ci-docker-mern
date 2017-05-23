A Docker image with:

* Ubunut 16.04
* Chrome
* Chromedriver
* Xvfb
* Rvm
* Npm

Built for MERN stacks (Mongo, Express, React, Node apps).

### Building
```
docker build -t mern .
```

### Deploying to docker hub

```
docker tag chrome coder36/mern
docker push coder36/mern
```


### Pulling from docker  - [https://hub.docker.com/r/coder36/mern](https://hub.docker.com/r/coder36/mern)
```
docker run -t -i coder36/mern

```


### Example `.gitlab-ci.yml`
```
image: "coder36/mern"

stages:
  - run_tests

cache:
  paths:
    - node_modules

mocha:
  stage: run_tests
  script:
  - yarn install
  - npm-run nf --procfile Procfile.test start > /dev/null 2>&1 & 
  - sleep 5
  - npm test
  - gem install dpl
  - dpl --provider=heroku --app=my_app --api-key=$HEROKU_API_KEY  
  environment:
    name: training
```
