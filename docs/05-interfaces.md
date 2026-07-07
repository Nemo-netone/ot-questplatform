# 05 · 接口契约

本文档定义前后端 HTTP API、字段示例、环境变量和错误约定。

## 1. 公共约定

基础响应：

```json
{
  "code": 200,
  "msg": "success",
  "data": {}
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| `code` | number | `200` 表示成功，其他值表示业务错误 |
| `msg` | string | 返回消息 |
| `data` | any | 业务数据 |

## 2. API 总表

| 方法 | 路径 | 说明 | 登录态 |
|------|------|------|--------|
| POST | `/user/login` | 用户登录 | 否 |
| POST | `/user/register` | 用户注册 | 否 |
| POST | `/user/logout` | 用户退出 | 是 |
| GET | `/survey/list` | 问卷列表 | 否 |
| POST | `/survey/updateStatus` | 更新问卷状态 | 是 |
| POST | `/survey/remove` | 逻辑删除问卷 | 是 |
| POST | `/survey/restore` | 恢复问卷 | 是 |
| GET | `/survey/detail?id={id}&type={type}` | 获取问卷详情，CloudBase 线上推荐路径 | 视 type 而定 |
| GET | `/survey/{id}/{type}` | 获取问卷详情，兼容旧路径 | 视 type 而定 |
| POST | `/survey/edit` | 创建/编辑问卷 | 是 |
| POST | `/answer/add` | 提交答卷 | 否 |
| POST | `/answer/list` | 答卷列表 | 是 |
| GET | `/api/qrcode` | 生成二维码 | 否 |

## 3. 接口详情

### 3.1 登录

`POST /user/login`

请求：

```json
{
  "username": "admin",
  "password": "******"
}
```

成功响应中的 `password` 会被置空：

```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "id": 1,
    "username": "admin",
    "phone": "123456",
    "status": 0,
    "token": "<jwt-like-token>"
  }
}
```

需要登录态的接口必须携带：

```http
Authorization: Bearer <token>
```

### 3.2 问卷列表

`GET /survey/list?isDelete=0&title=&page=1&pageSize=10`

响应：

```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "total": 3,
    "list": [
      {
        "id": 4,
        "title": "智能手机使用习惯调查",
        "status": 1,
        "creator": "marketing",
        "count": 3
      }
    ]
  }
}
```

### 3.3 创建/编辑问卷

`POST /survey/edit`

创建请求：

```json
{
  "username": "admin",
  "type": "insert",
  "formTitle": "用户满意度调查",
  "fields": [
    {
      "type": "radio",
      "title": "整体满意度如何？",
      "options": ["非常满意", "满意", "一般"]
    },
    {
      "type": "textarea",
      "title": "还有什么建议？"
    }
  ]
}
```

编辑请求需要额外传 `id`：

```json
{
  "username": "admin",
  "type": "update",
  "id": 2,
  "formTitle": "用户满意度调查",
  "fields": []
}
```

### 3.4 获取问卷详情

`GET /survey/detail?id={id}&type={type}`

旧路径 `GET /survey/{id}/{type}` 仍保留兼容，但 CloudBase Run HTTP 访问路由建议使用精确路径 `/survey/detail`，避免动态路径在网关层匹配不稳定。

`type` 可取：

| type | 说明 |
|------|------|
| `answer` | 正式填写，问卷必须启用 |
| `preview` | 预览 |
| `update` | 编辑，问卷不能处于启用状态 |

响应：

```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "id": 2,
    "title": "客户满意度调查",
    "questions": [
      {
        "id": 6,
        "surveyId": 2,
        "title": "您对我们的产品整体满意度如何？",
        "type": "radio",
        "options": [
          {
            "id": 7,
            "questionId": 6,
            "surveyId": 2,
            "optionId": 0,
            "content": "非常满意"
          }
        ]
      }
    ]
  }
}
```

### 3.5 提交答卷

`POST /answer/add`

请求：

```json
{
  "surveyId": 2,
  "sourceType": 2,
  "sourceIp": "127.0.0.1",
  "answers": "[{\"question\":\"整体满意度如何？\",\"answer\":\"满意\"}]"
}
```

### 3.6 答卷列表

`POST /answer/list`

请求：

```json
{
  "username": "admin",
  "surveyId": 2,
  "pageNum": 1,
  "pageSize": 10
}
```

### 3.7 二维码

`GET /api/qrcode?content={url}&width=200&height=200`

返回 `image/png`。

## 4. 默认示例账号

初始化脚本包含一个演示后台账号：

| 用途 | 用户名 | 密码 |
|------|--------|------|
| 本地演示后台登录 | `admin` | 见初始化 SQL 中 `user` 表示例数据 |

如公开展示项目，建议在 README 里说明这是演示账号，并在生产环境改为哈希密码。

## 5. 环境变量

| 变量 | 必填 | 敏感 | 说明 |
|------|------|------|------|
| `DB_URL` | 否 | 否 | PostgreSQL/Supabase JDBC 地址 |
| `DB_USERNAME` | 否 | 否 | PostgreSQL/Supabase 用户；Supabase pooler 常用 `<role>.<project-ref>`，线上使用专用角色 |
| `DB_PASSWORD` | 是 | 是 | PostgreSQL/Supabase 密码 |
| `DB_SSLMODE` | 否 | 否 | PostgreSQL SSL 模式，Supabase 线上建议 `require` |
| `DB_SCHEMA` | 否 | 否 | PostgreSQL schema，本项目线上使用 `ot_questplatform` |
| `APP_AUTH_SECRET` | 是 | 是 | token 签名密钥 |
| `APP_AUTH_TOKEN_TTL_SECONDS` | 否 | 否 | token 有效期 |
| `CORS_ALLOWED_ORIGINS` | 否 | 否 | 允许访问 API 的前端域名 |

## 6. 错误约定

| code | 场景 | 示例 msg |
|------|------|----------|
| 200 | 成功 | `success` |
| 400 | 业务校验失败 | `用户未登录`、`登录失败`、`问卷不存在或未启用` |
| 500 | 未捕获异常 | 当前由 Spring Boot 默认处理 |
