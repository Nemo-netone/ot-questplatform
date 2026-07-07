package com.wjh.quest.entity;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class Question {
    private long id;
    private long surveyId;
    private String title;
    private Date createTime; // 注意要导入java.util.Date
    private String type;
    private List<Option> options;
}
