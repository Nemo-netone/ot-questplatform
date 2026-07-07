package com.wjh.quest.controller;

import com.wjh.quest.entity.User;
import com.alibaba.fastjson.JSONObject;
import com.wjh.quest.service.AuthService;
import com.wjh.quest.service.UserService;
import com.wjh.quest.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestHeader;
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
    private AuthService authService;

    @PostMapping("login")
    public Result<JSONObject> login(@RequestBody User user) {
        // 登录
        User login = userService.login(user);
        if (Objects.isNull(login)) {
            return Result.error(400, "登录失败!");
        }

        String token = authService.issueToken(login);
        login.setPassword(null);

        JSONObject result = new JSONObject();
        result.put("id", login.getId());
        result.put("username", login.getUsername());
        result.put("phone", login.getPhone());
        result.put("status", login.getStatus());
        result.put("token", token);
        return Result.success(result);
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
    public Result logout(@RequestHeader(value = "Authorization", required = false) String authorization) {
        // JWT 为无状态令牌，退出由前端删除本地 token 完成。
        authService.getUsername(authorization);
        return Result.success();
    }
}
