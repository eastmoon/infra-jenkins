# Jenkins

## 指令

### Windows 環境

使用 ```jenkinsw.bat``` 做為服務的 CLI，此指令僅限於本應用服務執行於 Windows 環境

+ 啟動 Jenkins 服務

```
jenkinsw up
```

+ 關閉 Jenkins 服務

```
jenkinsw down
```

### Linux 環境
> 若需要 Linux 環境可使用 Vagrant & VirtualBox 啟用本專案提供的設定啟動虛擬環境，專案目錄會掛載於 ```~/git/infra-jenkins``` 




## 設定

本專案使用 Docker 啟用 Jenkins 服務，因此可參考 [Jenkins Docker install](https://www.jenkins.io/doc/book/installing/docker/) 文獻；再啟動後有三個主要步驟需處理：

+ [Unlocking Jenkins](https://www.jenkins.io/doc/book/installing/docker/#unlocking-jenkins)
    - 初次進入頁面時，需先解鎖 Jenkins
    - 本專案啟動服務透過掛載目錄 ```cache/jenkins-data/secrets/initialAdminPassword``` 取得解鎖密碼
+ [Initial plugins](https://www.jenkins.io/doc/book/installing/docker/#customizing-jenkins-with-plugins)
    - 選擇建議插件 ( suggested plugins )，相關插件可於啟用後在服務內重設定
    - 插件載入內容會存在於掛載目錄 ```cache/jenkins-data/plugins```
+ [Initial first administrator user](https://www.jenkins.io/doc/book/installing/docker/#creating-the-first-administrator-user)
    - 設定管理者用戶
    - 因 Jenkins 服務啟動後的內容會掛載於外部目錄，即使關閉並再次啟動服務，相關設定仍會保存

---

## 代理人 ( Agent )

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
