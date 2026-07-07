package com.wjh.quest.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wjh.quest.entity.Answer;
import com.wjh.quest.service.AnswerService;
import com.wjh.quest.service.AuthService;
import com.wjh.quest.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    private AuthService authService;

    @PostMapping("list")
    public Result<PageInfo<Answer>> get(@RequestHeader(value = "Authorization", required = false) String authorization,
                                        @RequestBody JSONObject param) {
        if (authService.getUsername(authorization) == null) {
            return Result.error(400, "用户未登录!");
        }

        return Result.success(answerServer.list(param));
    }
}
