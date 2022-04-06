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

+ Jenkins 開發模式

```
jenkinsw dev
```
> 開發模式會透過同步服務將透過 UI 設定完成的介面同步至 ```src``` 目錄，使對 Jenkins 的規劃可經由 git 進行版本控制

### Linux 環境
> 若需要 Linux 環境可使用 Vagrant & VirtualBox 啟用本專案提供的設定啟動虛擬環境，專案目錄會掛載於 ```~/git/infra-jenkins```

使用 ```jenkinsw.sh``` 做為服務的 CLI，此指令僅限於本應用服務執行於 Linux 環境

+ 啟動 Jenkins 服務

```
sudo bash jenkinsw.sh up
```

+ 關閉 Jenkins 服務

```
sudo bash jenkinsw.sh down
```

+ Jenkins 開發模式

```
sudo bash jenkinsw.sh dev
```
> 開發模式會透過同步服務將透過 UI 設定完成的介面同步至 ```src``` 目錄，使對 Jenkins 的規劃可經由 git 進行版本控制


## 介紹

#### [Introduction](https://www.tutorialspoint.com/jenkins/index.htm)

**Jenkins is a powerful application that allows continuous integration and continuous delivery of projects, regardless of the platform you are working on.**

![How it work](https://devopscube.com/wp-content/uploads/2020/03/jenkins-architecture-1024x657.png.webp)


### 初始化設定

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

需注意，本專案的 ```src``` 目錄內容，需完成初始化設定才會更新並正常使用；其無法於初始化設定前套入，主要問題是因 Jenkins plugins 尚未完成更新與安裝導致。

### 代理人 ( Agent )

+ 啟動 Agent 服務
    - Vagrant + Agent service
    - Vagrant + Agent Docker service
    - Agnet Docker service

### 腳本設計 ( Script Design )

腳本設計可看成兩種類型：

+ Jenkins 整體規劃腳本
+ Jenkins 單一工作腳本

前者是指若重建整個 Jenkins 時，要如何讓其設計結構得以透過 SCM 保存與管理；後者是指運行 Jenkins 工作時，其工作的對應工作腳本，這部分則可參考如下 Jenkins 主要的兩個工作 ( Job ) 方式：

+ Freestyle Job
    - Jenkins 標準工作，為單體運作單元，可用觸發器來啟動其他工作，但原則上工作間無共通處理與變數傳遞
    - 官方並無提供腳本化方案，可編寫 Shell script 並使用 SCM 管理導入
+ Pipeline Job
    - Jenkins 流程工作 ( Jenkins 2.0+ 版本適用 )，其執行是依據設計於中的腳本依序執行，使用 [Grovvy](https://www.eficode.com/blog/jenkins-groovy-tutorial) 語言
    - 官方有提供腳本化方案，可編寫 Jenkinsfile 並使用 SCM 管理導入

而前述所提的 Jenkins 整體規劃腳本，可採用兩種方式：

+ 第三方工具
    - [Jenkins Job Builder](https://docs.openstack.org/infra/jenkins-job-builder/index.html)
+ 設計開發模式
    - 以 Docker 啟動本機的 Jenkins 服務
    - 確保 Docker 掛載 ```config.xml``` 檔案、```jobs``` 目錄等
        + base on [eeacms/rsync](https://hub.docker.com/r/eeacms/rsync)
        + 啟用時 ```init.sh [source] to [cache]```
        + 開發時 ```sync.sh [cache] to [source]```，定期同步
        + 需注意，在未完成初始化設定時，使用開發模式腳本
    - 使用 UI 或 Blue Ocean 設定工作項目
    - 掛載內容即為版本控制內容，需注意要移除不必要的動態資料檔
    - 內容更新需重啟 Jenkisn 服務

原則上，Jenkins 的工作、用戶、視圖規劃可以上述方式導入與備份，以此確保內容管理可受到版本控制。

## Credentials

使用 credentials 來整理 Jenkins 各工作的統一憑證管理。

+ [Jenkins 使用 Credentials](https://www.jenkins.io/doc/book/using/using-credentials/)
    - [Freestyle 中使用 Build Environment 導入Credentials](https://stackoverflow.com/questions/35736377)
    - [Pipeline 中，git 服務使用 Credentials](https://stackoverflow.com/questions/38461705)
    - [Pipeline 中使用 Credentials](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials)

## 參考

+ [Jenkins](https://www.jenkins.io/)
    - [Jenkins wiki](https://zh.wikipedia.org/zh-tw/Jenkins_(%E8%BD%AF%E4%BB%B6))
+ [Jenkins dokcer](https://hub.docker.com/r/jenkins/jenkins)
    - [Jenkins 容器中執行 docker 指令](https://www.gss.com.tw/blog/jenkins-docker)
+ 架構介紹
    - [What is Jenkins: Features and Architecture Explained](https://www.simplilearn.com/tutorials/jenkins-tutorial/what-is-jenkins)
    - [Jenkins Architecture Explained – Beginners Guide](https://devopscube.com/jenkins-architecture-explained/)
    - [Jenkins Pipeline Tutorial For Beginners](https://devopscube.com/jenkins-pipeline-as-code/)
+ 相關技術
    - [Jenkins Pipeline Tutorial For Beginners](https://devopscube.com/jenkins-pipeline-as-code/)
        + [Main differences between Freestyle - Scripted Pipeline Job - Declarative Pipeline Job](https://support.cloudbees.com/hc/en-us/articles/115003908372)
        + [Jenkins Hands-On Freestyle & Pipeline Jobs, and Scripts Configuration](https://faun.pub/jenkins-jobs-hands-on-for-the-different-use-cases-devops-b153efb483c7)
        + [Configuring a Jenkins Pipeline using a YAML file](https://medium.com/wolox/dynamic-jenkins-pipelines-b04066371fbc)
    - [Travis-CI vs Jenkins: What is the difference?](D:\Document\Gitlab\DEVOPS\iwa-devops)
        + **small open source projects are best suited for Travis CI as it is easy to run and quick to set up. On the other hand, large enterprise is best suited to Jenkins as it offers free licensing for a private project and a wide range of customizable feature.**
        + [Travis CI vs Gitlab CI](https://knapsackpro.com/ci_comparisons/travis-ci/vs/gitlab-ci)
            - 依據眾多參考文獻可知，Travis CI 與 Gitlab CI 在功能與操作性上高度重疊，因此若僅需要專案獨立編譯與部屬，可使用 Gitlab CI 替代
            - [Gitlab CI/CD 簡單介紹](https://kheresy.wordpress.com/2019/02/13/gitlab-ci-cd/)
    - [如何於 Docker 服務中使用 Docker 服務](https://github.com/eastmoon/research-docker-in-docker)
