package com.wjh.quest.controller;

import com.wjh.quest.entity.User;
import com.wjh.quest.service.RedisService;
import com.wjh.quest.service.UserService;
import com.wjh.quest.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@RestController
@RequestMapping("user")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private RedisService redisService;

    @PostMapping("login")
    public Result<User> login(@RequestBody User user) {
        // 登录
        User login = userService.login(user);
        if (Objects.isNull(login)) {
            return Result.error(400, "登录失败!");
        }

        // 登录成功后缓存用户登录态，避免把明文密码返回给前端或写入Redis。
        login.setPassword(null);
        redisService.putValue("user:login" + login.getUsername(), login, 60 * 60 * 24);
        return Result.success(login);
    }

    @PostMapping("register")
    public Result register(@RequestBody User user) {
        // 判断用户名是否存在
        if (Objects.nonNull(userService.findByUsername(user.getUsername()))) {
            return Result.error(400, "用户名已存在!");
        }
        userService.register(user);
        return Result.success();
    }

    @PostMapping("logout")
    public Result logout(@RequestBody User user) {
        // 登出删除redis用户信息
        redisService.deleteValue("user:login" + user.getUsername());
        return Result.success();
    }
}
