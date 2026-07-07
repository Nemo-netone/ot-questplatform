package com.wjh.quest.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjh.quest.dao.AnswerMapper;
import com.wjh.quest.dao.OptionMapper;
import com.wjh.quest.dao.QuestionMapper;
import com.wjh.quest.dao.SurveyMapper;
import com.wjh.quest.entity.Option;
import com.wjh.quest.entity.Question;
import com.wjh.quest.entity.Survey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SurveyService {
    @Autowired
    private SurveyMapper surveyMapper;

    @Autowired
    private AnswerMapper answerMapper;

    public PageInfo<JSONObject> get(int isDelete, String title, int page, int pageSize) {
        // 分页
        PageHelper.startPage(page, pageSize);
        // 获取分页问卷
        List<Survey> surveys = surveyMapper.get(isDelete, title);
        PageInfo<Survey> surveyPageInfo = new PageInfo<>(surveys);

        // 问卷信息处理
        List<JSONObject> result = new ArrayList<>();
        surveys.forEach(survey -> {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id", survey.getId());
            jsonObject.put("title", survey.getTitle());
            jsonObject.put("createTime", survey.getCreateTime());
            jsonObject.put("isDelete", survey.getIsDelete());
            jsonObject.put("status", survey.getStatus());
            jsonObject.put("creator", survey.getCreator());
            // 获取问卷答题数
            int count = answerMapper.getCountBySurveyId(survey.getId());
            jsonObject.put("count", count);
            result.add(jsonObject);
        });

        // 处理返回结果
        PageInfo<JSONObject> pageInfo = new PageInfo<>(result);
        pageInfo.setTotal(surveyPageInfo.getTotal());
        return pageInfo;
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(JSONObject param) {
        Long surveyId = param.getLong("surveyId");
        int status = param.getIntValue("status");
        surveyMapper.updateStatus(surveyId, status);
    }

    @Transactional(rollbackFor = Exception.class)
    public void removeById(long id) {
        surveyMapper.removeById(id);
    }

    public int getStatus(Long id) {
        return surveyMapper.getStatus(id);
    }

    @Transactional(rollbackFor = Exception.class)
    public void restoreById(long id) {
        surveyMapper.restoreById(id);
    }

    public Survey getById(Long id) {
        return surveyMapper.getById(id);
    }

    @Autowired
    private OptionMapper optionMapper;

    @Autowired
    private QuestionMapper questionMapper;

    @Transactional(rollbackFor = Exception.class)
    public void insert(JSONObject param) {
        // 新增问卷
        Survey survey = new Survey();
        survey.setTitle(param.getString("formTitle"));
        survey.setCreator(param.getString("username"));
        surveyMapper.insert(survey);

        insertQuestions(survey.getId(), param.getJSONArray("fields"));
    }

    private void insertQuestions(Long surveyId, JSONArray fields) {
        // 新增问卷问题
        for (Object field : fields) {
            JSONObject jsonObject = (JSONObject) JSON.toJSON(field);
            Question question = new Question();
            question.setSurveyId(surveyId);
            question.setTitle(jsonObject.getString("title"));
            question.setType(jsonObject.getString("type"));
            questionMapper.insert(question);

            // 新增选项
            if (jsonObject.containsKey("options")) {
                JSONArray options = jsonObject.getJSONArray("options");
                for (int i = 0; i < options.size(); i++) {
                    Option option = new Option();
                    option.setSurveyId(surveyId);
                    option.setQuestionId(question.getId());
                    option.setContent(String.valueOf(options.get(i)));
                    option.setOptionId(i);
                    optionMapper.insert(option);
                }
            }
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void update(JSONObject param) {
        Long surveyId = param.getLong("id");
        surveyMapper.updateTitle(surveyId, param.getString("formTitle"));
        // 保留问卷主键和历史答卷，只重建题目和选项。
        optionMapper.deleteBySurveyId(surveyId);
        questionMapper.deleteBySurveyId(surveyId);
        insertQuestions(surveyId, param.getJSONArray("fields"));
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteBySurveyId(long id) {
        // 删除问卷
        surveyMapper.deleteById(id);
        // 删除选项
        optionMapper.deleteBySurveyId(id);
        // 删除问题
        questionMapper.deleteBySurveyId(id);
    }

}
