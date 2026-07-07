# Deployment

本文记录 Quest Survey Platform 的部署策略。当前项目是 Spring Boot 单体应用，Cloudflare Pages 只适合发布静态前端资源；Java API、MySQL 和 Redis 需要由本地环境或后端服务器单独运行。

## 1. Cloudflare Pages 静态预览

| 项目 | 值 |
|------|----|
| GitHub 仓库 | `Nemo-netone/ot-questplatform` |
| 发布分支 | `main` |
| Pages 项目名 | `ot-questplatform` |
| 生产分支 | `main` |
| 发布目录 | `src/main/resources/static` |
| 目标默认地址 | `https://ot-questplatform.pages.dev` |

固定地址的关键是：后续不要创建新的 Pages 项目，继续部署到同一个 `ot-questplatform` Pages 项目。Cloudflare Pages 的默认域名由项目名决定，同一个项目重复部署后地址保持不变。

## 2. 部署边界

Cloudflare Pages 发布后可以打开静态页面，例如：

```text
https://ot-questplatform.pages.dev/index.html
https://ot-questplatform.pages.dev/page/login.html
https://ot-questplatform.pages.dev/page/answer.html
```

但这些页面仍会调用相对路径 API，例如 `/user/login`、`/survey/list`、`/answer/add`。如果没有把 Spring Boot API 部署到同域名、反向代理或独立后端域名，页面能打开，但业务接口不会完整工作。

## 3. Wrangler 发布命令

凭据只放在本机环境变量或 Cloudflare 控制台，不写入仓库文件。

```powershell
$env:CLOUDFLARE_ACCOUNT_ID="<cloudflare-account-id>"
$env:CLOUDFLARE_API_TOKEN="<cloudflare-api-token>"

wrangler pages project create ot-questplatform --production-branch main
wrangler pages deploy src/main/resources/static `
  --project-name ot-questplatform `
  --branch main `
  --commit-hash $(git rev-parse HEAD) `
  --commit-message "deploy: static preview"
```

如果 Pages 项目已经存在，跳过 `project create`，只执行 `pages deploy`。

## 4. GitHub 连接式发布

也可以在 Cloudflare Dashboard 中连接 GitHub 仓库：

| 配置项 | 值 |
|--------|----|
| Repository | `Nemo-netone/ot-questplatform` |
| Production branch | `main` |
| Build command | 留空 |
| Build output directory | `src/main/resources/static` |
| Root directory | `/` |

这种方式适合长期维护：以后推送到 `main` 后，Cloudflare Pages 会自动重新发布，默认地址仍保持 `https://ot-questplatform.pages.dev`。

## 5. 发布前检查

- [ ] `git status --short --branch` 显示当前分支为 `main`。
- [ ] `git push` 已把最新提交推到 `origin/main`。
- [ ] Wrangler 当前凭据能访问目标 Cloudflare Account。
- [ ] Pages 项目名仍为 `ot-questplatform`。
- [ ] 发布目录仍为 `src/main/resources/static`。
- [ ] 仓库没有提交 `.env`、token、数据库密码或云服务密钥。
