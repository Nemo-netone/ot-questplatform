package com.wjh.quest.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wjh.quest.entity.Answer;
import com.wjh.quest.entity.User;
import com.wjh.quest.service.AnswerService;
import com.wjh.quest.service.RedisService;
import com.wjh.quest.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@RestController
@RequestMapping("answer")
public class AnswerController {
    @Autowired
    private AnswerService answerServer;

    @PostMapping("add")
    public Result add(@RequestBody JSONObject param) {
        answerServer.insert(param);
        return Result.success();
    }

    @Autowired
    private RedisService redisService;

    @PostMapping("list")
    public Result<PageInfo<Answer>> get(@RequestBody JSONObject param) {
        // 判断用户是否登录
        User user = redisService.getValue("user:login" + param.getString("username"), User.class);
        if (Objects.isNull(user)) {
            return Result.error(400, "用户未登录!");
        }

        return Result.success(answerServer.list(param));
    }
}