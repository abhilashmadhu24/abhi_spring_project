Hi,

This is a simple demonstration of sample java-spring-boot project integration with GitLab + Jenkins + Docker + Private docker registry.  
```
Tools used : 
    1. Gitlab
    2. Jenkins CI/CD
    3. Spring boot maven free sample code
    4. docker
    5. nexus repository
    6. Nginx for proxy service ( if needed )
```
    
   ![Spring_project](https://user-images.githubusercontent.com/50264439/131611090-ddd81f43-9d10-4621-89a2-4db3ed0d0705.jpeg)

    
Working:

Here I have used my private gitlab repository for cloning codes to my jenkins server. For convience, I have added codes in my github repo too.

As testing purpose, I have installed nexus on same jenkins server.

When gitlab commit is triggered, jenkins will start build, test , create docker image and pull to registry

Pipelined architecture is used

Steps:

Install jenkins and create a new project as Pipelined project

Follow this url for jenkins installation : https://linuxize.com/post/how-to-install-jenkins-on-ubuntu-18-04/

After login to jenkins >> dashboard >> new item >> Pipeline >> OK

![spring1](https://user-images.githubusercontent.com/50264439/131609336-725337ee-f7e7-468f-a7de-e5dce97c694f.png)


Provide your repository project url gitlab/gitbucket..etc on Project URL section

![spring2](https://user-images.githubusercontent.com/50264439/131610683-3663ae44-3e14-4adb-a612-aeee937041aa.png)



Add your pipeline script . I have used groovy syntax and script available on repo as Pipeline_script.txt

![spring3](https://user-images.githubusercontent.com/50264439/131610670-d7c31b1a-2dde-4afc-8db3-e301d1eafd1d.png)



Pass needed credentials dynamically during runtime by jenkins >> manage jenkins >> manage credentials >> choose jenkins from below
Create user and copy credentialsId

You can now use this credentialsID instead of passwords in pipeline script

Nexus repo-management

Follow this url for nexus  installation : https://www.howtoforge.com/how-to-install-and-configure-nexus-repository-manager-on-ubuntu-20-04/

After login to nexus >> Repository >> create repository >> Docker (hosted) >> done
Users >> Create local user >> done
Realms >> Click on Docker Bearer Token Realm >> Move to active
More details at https://blog.sonatype.com/setting-up-a-secure-private-nexus-repository


Now you need to change the respective credentials and urls in pipeline as of yours and build job.

After building and sending to registry server, we cann pull it based on tag_value and deploy on our server. 
```
>> docker pull localhost:8091/repository/abhi_repo/abhi_project:<tag_value>
>> docker run -d -p 8090:8090 abhi_petclinic
```
Our Application will listen on 8090 based on configurations I have given during docker image creation, we can use an NginX proxy before this to overcome this and improve efficiency.

```
>> apt-get install nginx
>> unlink /etc/nginx/sites-enabled/default
>> cd etc/nginx/sites-available/
>> vi reverse-proxy.conf and add below lines


server {
    listen 80;
    location / {
        proxy_pass http://<localhost:8090>;
    }
}


>> ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

>> service nginx configtest
>> service nginx restart

```

Done, here you go and happy troubleshooting..!!!!!!!!!!!!
