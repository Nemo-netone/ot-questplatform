# Deployment

本文记录 Quest Survey Platform 的部署策略。当前推荐形态是：Cloudflare Pages 发布静态前端，CloudBase Run 托管 Spring Boot API，Supabase PostgreSQL 保存业务数据。

## 1. Cloudflare Pages 静态预览

| 项目 | 值 |
|------|----|
| GitHub 仓库 | `Nemo-netone/ot-questplatform` |
| 发布分支 | `main` |
| Pages 项目名 | `ot-questplatform` |
| 生产分支 | `main` |
| 发布目录 | `src/main/resources/static` |
| 已发布地址 | `https://ot-questplatform.pages.dev` |
| 首次发布时间 | 2026-07-07 |

固定地址的关键是：后续不要创建新的 Pages 项目，继续部署到同一个 `ot-questplatform` Pages 项目。Cloudflare Pages 的默认域名由项目名决定，同一个项目重复部署后地址保持不变。

具体某一次部署的短 ID、快照地址和提交号以 Cloudflare Pages 控制台或 `wrangler pages deployment list --project-name ot-questplatform` 为准，不在文档中长期固化，避免记录过期。

## 2. 部署边界

Cloudflare Pages 发布后可以打开静态页面，例如：

- `https://ot-questplatform.pages.dev/index.html`
- `https://ot-questplatform.pages.dev/page/login.html`
- `https://ot-questplatform.pages.dev/page/answer.html`

静态页面通过 `src/main/resources/static/js/app-config.js` 中的 `QuestConfig.apiUrl()` 访问后端。未配置 API 基址时，请求会打到同域名；部署 CloudBase 后，应把 `QUEST_API_BASE_URL` 或 `localStorage.QUEST_API_BASE_URL` 设置为 CloudBase 后端地址。

临时测试远程 API 可以在浏览器地址后追加：

```text
https://ot-questplatform.pages.dev/page/login.html?apiBase=https://<cloudbase-api-domain>
```

该地址会写入浏览器 `localStorage`，后续页面会继续使用这个 API 基址。

## 3. 平台控制台入口

这些地址只用于登录和授权，不在仓库中记录任何 token、数据库密码或云服务密钥。

| 平台 | 用途 | 登录地址 |
|------|------|----------|
| Cloudflare Pages | 查看 `ot-questplatform` 静态前端部署、绑定 GitHub 自动发布 | <https://dash.cloudflare.com> |
| CloudBase / 腾讯云开发 | 部署 Spring Boot 后端服务、配置环境变量、查看服务域名 | <https://console.cloud.tencent.com/tcb> |
| Supabase | 创建 PostgreSQL 项目、执行初始化 SQL、复制 JDBC 连接信息 | <https://supabase.com/dashboard> |

完整功能上线需要三件事：

1. Supabase 已执行 `docs/database/quest-platform-postgres.sql`。
2. CloudBase Run 已部署本仓库 Dockerfile 构建出的 Spring Boot API，并配置 `DB_*`、`APP_AUTH_SECRET`、`CORS_ALLOWED_ORIGINS`。
3. Cloudflare Pages 前端通过 `apiBase` 或 `QUEST_API_BASE_URL` 指向 CloudBase 后端公开域名。

## 4. CloudBase Run 后端部署

后端使用仓库根目录的 `Dockerfile` 构建 Spring Boot 容器。CloudBase Run 需要配置以下环境变量：

| 环境变量 | 说明 |
|----------|------|
| `DB_URL` | Supabase PostgreSQL JDBC 地址，通常需要 `sslmode=require` |
| `DB_USERNAME` | Supabase 数据库用户名 |
| `DB_PASSWORD` | Supabase 数据库密码 |
| `APP_AUTH_SECRET` | token 签名密钥，必须使用长随机字符串 |
| `APP_AUTH_TOKEN_TTL_SECONDS` | 登录有效期，默认 `86400` |
| `CORS_ALLOWED_ORIGINS` | 允许访问 API 的前端域名，例如 `https://ot-questplatform.pages.dev` |

Supabase 初始化脚本：

```text
docs/database/quest-platform-postgres.sql
```

当前本机 CloudBase CLI 尚未登录。可用以下方式授权：

```powershell
tcb login
```

或在控制台登录后，通过 CloudBase Run 连接 GitHub 仓库并选择本仓库根目录的 `Dockerfile` 进行云端构建。

## 5. Wrangler 发布命令

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

## 6. GitHub 连接式发布

也可以在 Cloudflare Dashboard 中连接 GitHub 仓库：

| 配置项 | 值 |
|--------|----|
| Repository | `Nemo-netone/ot-questplatform` |
| Production branch | `main` |
| Build command | 留空 |
| Build output directory | `src/main/resources/static` |
| Root directory | `/` |

这种方式适合长期维护：以后推送到 `main` 后，Cloudflare Pages 会自动重新发布，默认地址仍保持 `https://ot-questplatform.pages.dev`。

## 7. 发布前检查

- [ ] `git status --short --branch` 显示当前分支为 `main`。
- [ ] `git push` 已把最新提交推到 `origin/main`。
- [ ] Wrangler 当前凭据能访问目标 Cloudflare Account。
- [ ] Pages 项目名仍为 `ot-questplatform`。
- [ ] 发布目录仍为 `src/main/resources/static`。
- [ ] 仓库没有提交 `.env`、token、数据库密码或云服务密钥。
- [ ] Supabase 已执行 `docs/database/quest-platform-postgres.sql`。
- [ ] CloudBase Run 已配置 `DB_*`、`APP_AUTH_SECRET` 和 `CORS_ALLOWED_ORIGINS`。
