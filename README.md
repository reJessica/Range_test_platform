# 网盾探隅——智能靶场漏洞测试平台部署文档

## 项目情况

+ 开发工具：Visual Studio Code
+ 插件：
	- EditorConfig for VS Code
	- ESLint
	- Stylelint
+ 编辑工具：node 
+ 包管理工具：Yarn 
+ 运行环境：
	- 推荐 Chrome 浏览器，其他现代浏览器不保证完全兼容
	- 屏幕分辨率 >= 1024
+ 前端采用Vue、Element UI。

+ 后端采用Spring Boot、Spring Security、Redis & Jwt。
+ 项目构建：Maven
+ mysql，redis服务器
+ 语言：C，C++，Java，JavaScript，Less，Vue

## 程序清单

基本环境依赖

| 安装包                            | 用途                        |
| --------------------------------- | --------------------------- |
| cgicc-lib-3.2.16-1.el7.x86_64.tar | 用于创建CGI应用程序         |
| cppdb-lib-0.3.1-1.el7.x86_64.tar  | 一个C++的轻量级数据库连接库 |
| protobuf-3.8.0-1.el7.x86_64.tar   | 用于序列化结构化数据的机制  |
| db.server.v1.1.231123.tar         | 数据库文件                  |

程序部署包

| 安装包                                    | 用途                                                   |
| ----------------------------------------- | ------------------------------------------------------ |
| Agent.v1.1.0.231124.tar                   | 监控，管理代理程序                                     |
| lyprobe-release-v1.0.1.tar                | 探测监控工具，探针                                     |
| pf_ring-lib-7.4.0-957.el7.x86_64.E5v2.tar | 高性能网络包捕获库，通常用于网络监控和分析。           |
| Server.v1.1.1.240101.tar                  | 一个服务器应用程序或服务软件包                         |
| tensorflow-2.0.4-1.el7.x86_64.tar         | 一个开源的机器学习框架，广泛用于深度学习和人工智能应用 |
| webui.v1.1.0.tar                          | Web用户界面应用程序                                    |



## 程序部署

1.将 localyumsource.tar.gz 解压至 /root 目录下，执行 all_env.sh 脚本，离线安装依赖环境。

2.执行 agent_deploy_relese.sh 脚本，完成探针与分析节点的部署。

3.执行 server_deploy_release.sh 脚本，完成管理节点与可视化界面的部署。

4.初始化数据库，根据提示多次手动设置密码，输入密码。注意密码输入保持一致。

5.在/etc/rc.local 文件中，通过-i参数指定所监听的网卡（默认写ens224），根据网卡信息自主更改此参数。执行该脚本，运行探针lyproe 与接收程序 nfcapd。

6.启动探针监听网卡，接入回放的流量或真实流量（提供模拟数据包压缩包pcap_file.tar），重放文件即可。

7.编辑src/main/ resources目录下的application-druid.yml 文件，修改数据库地址账号信息。

8.执行challenge2024.sql文件获取数据库数据。

9.启动RuoYiApplication.java，打开浏览器，输入：http://localhost:8080/captchaImage，若能正确显示返回信息，搭建后台成功。

10.启动前端展示界面

```
cd ruoyi-ui
npm install 
npm run dev
```

打开浏览器，输入：http://localhost:80 （默认账户 admin/admin123）

若能正确展示登录页面，并能成功登录，菜单及页面展示正常，则表明环境搭建成功



### 4.验证

  可以从以下步骤，进行系统数据流转测试验证：

1.验证接收器能够正常接收数据： `/data/flow/3/` 目录下是否存在 `nfcapd` 文件，且单个文件大小大于276字节。

2.分析引擎正常产出数据： `/Agent/data/db/` 目录下是否存在 以日期命名的目录，且日期目录中不为空。

3.管理端、Web可视化页面正常显示数据：WEB端访问正常，检测到测试数据中存在的告警事件。

**注意:**  系统为流水线式作业，每个节点间数据流转存在约5分钟的时间差，从接入流量至web端监测到告警，存在15分钟左右的延迟。

**注意:**  系统主页面仅展示告警信息，不对正常流量进行展示。可通过搜索框搜索指定的IP、端口、域名，查询目标的全部会话。

**注意：**若出现页面无法显示的问题，可以在系统管理-菜单管理-中设置权限以及路由路径（本质是修改数据库数据），由此可进行相关访问。

**注意**：启动本地开发环境报错 `error:0308010C:digital envelope routines::unsupported`。则在 `packages/std/package.json`文件的start命中添加参数 `--openssl-legacy-provider`，修改为 `"start": "cross-env REACT_APP_ENV=dev react-app-rewired --openssl-legacy-provider start"`。



