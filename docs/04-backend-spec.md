# 04 · 后端规格

本文档定义后端模块职责、核心业务编排、错误处理、配置和测试策略。

## 1. 模块划分

| 模块 | 路径 | 职责 |
|------|------|------|
| 启动入口 | `QuestApplication.java` | Spring Boot 启动，扫描 Mapper |
| 用户控制器 | `controller/UserController.java` | 登录、注册、退出 |
| 问卷控制器 | `controller/SurveyController.java` | 问卷列表、状态、删除、恢复、详情、编辑 |
| 答卷控制器 | `controller/AnswerController.java` | 提交答卷、查询答卷 |
| 二维码控制器 | `controller/QRCodeController.java` | 生成 PNG 二维码 |
| 用户服务 | `service/UserService.java` | 用户查询和注册事务 |
| 问卷服务 | `service/SurveyService.java` | 问卷、题目、选项写入和查询编排 |
| 问题服务 | `service/QuestionService.java` | 问题与选项组装 |
| 答卷服务 | `service/AnswerService.java` | 答卷写入和分页查询 |
| 认证服务 | `service/AuthService.java` | 签发和校验 HMAC token |
| Web 配置 | `config/WebConfig.java` | CORS 配置 |

## 2. 核心抽象

| 类型 | 说明 |
|------|------|
| `Result<T>` | 统一响应结构，包含 `code`、`msg`、`data` |
| `Survey` | 问卷主实体 |
| `Question` | 问卷题目实体，包含可选的 `List<Option>` |
| `Option` | 题目选项实体 |
| `Answer` | 答卷实体，`answer` 字段保存 JSON 字符串 |
| `User` | 后台用户实体 |

## 3. 业务编排

### 3.1 登录

```text
UserController.login
  -> UserService.login
  -> UserMapper.login
  -> login.setPassword(null)
  -> AuthService.issueToken
  -> Result.success(user profile + token)
```

### 3.2 问卷查询

```text
SurveyController.get
  -> PageHelper.startPage
  -> SurveyMapper.get
  -> AnswerMapper.getCountBySurveyId
  -> PageInfo<JSONObject>
```

### 3.3 问卷编辑

创建：

```text
SurveyService.insert
  -> surveyMapper.insert
  -> insertQuestions
  -> questionMapper.insert
  -> optionMapper.insert
```

更新：

```text
SurveyService.update
  -> surveyMapper.updateTitle
  -> questionMapper.deleteBySurveyId
  -> optionMapper.deleteBySurveyId
  -> insertQuestions
```

更新保留 `survey.id` 和历史答卷，避免答卷关系断裂。

## 4. 事务边界

| 方法 | 事务 | 说明 |
|------|------|------|
| `UserService.register` | 是 | 注册用户 |
| `SurveyService.insert` | 是 | 问卷、题目、选项一起写入 |
| `SurveyService.update` | 是 | 标题更新、题目和选项重建 |
| `SurveyService.removeById` | 是 | 逻辑删除 |
| `SurveyService.restoreById` | 是 | 恢复 |
| `AnswerService.insert` | 是 | 提交答卷 |

## 5. 错误矩阵

| 场景 | 当前返回 | 影响 | 后续建议 |
|------|----------|------|----------|
| 登录失败 | `400 登录失败` | 无法进入后台 | 增加错误码枚举 |
| 未登录操作 | `400 用户未登录` | 拒绝后台写操作 | 抽成拦截器 |
| 启用问卷被删除 | `400 问卷为开启状态不可删除` | 保护公开问卷 | 保持 |
| 未启用问卷填写 | `400 问卷未开启不可操作` | 禁止受访者提交 | 保持 |
| token 缺失或过期 | `400 用户未登录` | 拒绝后台写操作 | 后续抽成拦截器 |
| 数据库不可用 | 请求异常 | 主链路不可用 | 增加健康检查 |

## 6. 配置

| 配置 | 来源 | 说明 |
|------|------|------|
| `DB_URL` | 环境变量 | JDBC 地址 |
| `DB_USERNAME` | 环境变量 | PostgreSQL/Supabase 用户 |
| `DB_PASSWORD` | 环境变量 | PostgreSQL/Supabase 密码 |
| `DB_SSLMODE` | 环境变量 | PostgreSQL SSL 模式，Supabase 线上建议 `require` |
| `DB_SCHEMA` | 环境变量 | PostgreSQL schema，本项目线上使用 `ot_questplatform` |
| `APP_AUTH_SECRET` | 环境变量 | token 签名密钥 |
| `APP_AUTH_TOKEN_TTL_SECONDS` | 环境变量 | token 有效期 |
| `CORS_ALLOWED_ORIGINS` | 环境变量 | 允许访问 API 的前端域名 |

## 7. 测试策略

| 层级 | 当前 | 后续建议 |
|------|------|----------|
| 编译 | `mvn -DskipTests compile` | CI 必跑 |
| 打包 | `mvn clean package -DskipTests` | CI 必跑 |
| Spring 上下文 | `QuestApplicationTests` | 使用测试 profile 或 Testcontainers |
| Mapper | 暂无 | 加 MyBatis 集成测试 |
| Controller | 暂无 | MockMvc 覆盖核心接口 |
| 架构边界 | 暂无 | ArchUnit 检查分层依赖 |

## 8. 安全边界

- 真实数据库密码不得提交。
- 登录接口不得返回明文密码。
- token 签名密钥不得提交。
- 当前密码仍为明文存储，只适合作品演示和学习，不适合生产。
