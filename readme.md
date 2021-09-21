# Jenkins

## 指令

+ 啟動 Jenkins 服務

```
ansiblew start
```

+ 啟動 Agent 服務
    - Vagrant + Agent service
    - Vagrant + Agent Docker service
    - Agnet Docker service

---

+ Jenkins 在啟動服務後才安裝 plugin
+ Jenkins 在啟動服務後才設定主要帳戶 ?
+ Jenkins 的 Agent 設定

---

疑問：如何讓 Docker container 控制外部腳本或啟動其他容器

+ [Docker Tips : about /var/run/docker.sock](https://betterprogramming.pub/about-var-run-docker-sock-3bfd276e12fd)
+ [Control Docker containers from within container](https://fredrikaverpil.github.io/2018/12/14/control-docker-containers-from-within-container/)
+ [Docker Privileged - Should You Run Privileged Docker Containers?](https://phoenixnap.com/kb/docker-privileged)

---

## 介紹

#### [Introduction](https://www.tutorialspoint.com/jenkins/index.htm)

**Jenkins is a powerful application that allows continuous integration and continuous delivery of projects, regardless of the platform you are working on.**

![How it work](https://devopscube.com/wp-content/uploads/2020/03/jenkins-architecture-1024x657.png.webp)

##

## 參考

+ [Jenkins](https://www.jenkins.io/)
    - [Jenkins wiki](https://zh.wikipedia.org/zh-tw/Jenkins_(%E8%BD%AF%E4%BB%B6))
+ [Jenkins dokcer](https://hub.docker.com/r/jenkins/jenkins)
    - [Jenkins 容器中執行 docker 指令](https://www.gss.com.tw/blog/jenkins-docker)
+ 架構介紹
    - [What is Jenkins: Features and Architecture Explained](https://www.simplilearn.com/tutorials/jenkins-tutorial/what-is-jenkins)
    - [Jenkins Architecture Explained – Beginners Guide](https://devopscube.com/jenkins-architecture-explained/)
+ 相關技術
    - [Jenkins Pipeline Tutorial For Beginners](https://devopscube.com/jenkins-pipeline-as-code/)
