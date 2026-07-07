package com.wjh.quest.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wjh.quest.entity.Question;
import com.wjh.quest.entity.Survey;
import com.wjh.quest.service.QuestionService;
import com.wjh.quest.service.AuthService;
import com.wjh.quest.service.SurveyService;
import com.wjh.quest.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("survey")
public class SurveyController {
    @Autowired
    private SurveyService surveyServer;

    @GetMapping("list")
    public Result<PageInfo<JSONObject>> get(@RequestParam("isDelete") int isDelete,
                                            @RequestParam("title") String title,
                                            @RequestParam("page") int page,
                                            @RequestParam("pageSize") int pageSize) {
        return Result.success(surveyServer.get(isDelete, title, page, pageSize));
    }

    @Autowired
    private AuthService authService;

    @PostMapping("updateStatus")
    public Result updateStatus(@RequestHeader(value = "Authorization", required = false) String authorization,
                               @RequestBody JSONObject param) {
        if (!fillAuthenticatedUsername(authorization, param)) {
            return Result.error(400, "用户未登录!");
        }

        surveyServer.updateStatus(param);

        return Result.success();
    }

    @PostMapping("remove")
    public Result removeById(@RequestHeader(value = "Authorization", required = false) String authorization,
                             @RequestBody JSONObject param) {
        if (!fillAuthenticatedUsername(authorization, param)) {
            return Result.error(400, "用户未登录!");
        }

        // 查看问卷状态
        int status = surveyServer.getStatus(param.getLong("surveyId"));
        if (status == 1) {
            return Result.error(400, "问卷为开启状态,不可删除!");
        }

        // 逻辑删除问卷
        surveyServer.removeById(param.getLong("surveyId"));

        return Result.success();
    }

    @PostMapping("restore")
    public Result restoreById(@RequestHeader(value = "Authorization", required = false) String authorization,
                              @RequestBody JSONObject param) {
        if (!fillAuthenticatedUsername(authorization, param)) {
            return Result.error(400, "用户未登录!");
        }

        // 恢复问卷
        surveyServer.restoreById(param.getLong("surveyId"));
        return Result.success();
    }

    @Autowired
    private QuestionService questionServer;

    @GetMapping("detail")
    public Result<JSONObject> detail(@RequestParam("id") long id,
                                     @RequestParam("type") String type) {
        return getSurveyDetail(id, type);
    }

    @GetMapping("{id}/{type}")
    public Result<JSONObject> getById(@PathVariable("id") long id,
                                      @PathVariable("type") String type) {
        return getSurveyDetail(id, type);
    }

    private Result<JSONObject> getSurveyDetail(long id, String type) {
        // 获取问卷
        Survey survey = surveyServer.getById(id);
        if (Objects.isNull(survey)) {
            return Result.error(400, "问卷不存在或未启用!");
        }

        if ("answer".equals(type) && survey.getStatus() == 0) {
            // 回答问卷,当问卷未开启不能操作
            return Result.error(400, "问卷为未开启状态,不可操作!");
        } else if ("update".equals(type) && survey.getStatus() == 1) {
            // 编辑问卷,当问卷开启时不能操作
            return Result.error(400, "问卷为开启状态,不可操作!");
        }

        // 获取问卷问题
        List<Question> questions = questionServer.getQuestion(id);

        // 封装结果
        JSONObject result = new JSONObject();
        result.put("id", survey.getId());
        result.put("title", survey.getTitle());
        result.put("questions", questions);

        return Result.success(result);
    }

    @PostMapping("edit")
    public Result edit(@RequestHeader(value = "Authorization", required = false) String authorization,
                       @RequestBody JSONObject param) {
        JSONArray fields = param.getJSONArray("fields");

        if (!fillAuthenticatedUsername(authorization, param)) {
            return Result.error(400, "用户未登录!");
        }

        // 判断问题列表是否为空
        if (CollectionUtils.isEmpty(fields)) {
            return Result.error(400, "问卷问题不能为空!");
        }

        // 根据type来判断新增还是修改
        if ("insert".equals(param.getString("type"))) {
            surveyServer.insert(param);
        } else {
            surveyServer.update(param);
        }

        return Result.success();
    }

    private boolean fillAuthenticatedUsername(String authorization, JSONObject param) {
        String username = authService.getUsername(authorization);
        if (username == null) {
            return false;
        }
        param.put("username", username);
        return true;
    }
}
