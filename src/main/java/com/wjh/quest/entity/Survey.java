package com.wjh.quest.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Survey {
    private long id;
    private String title;
    private int status;
    private Date createTime; // 注意要导入java.util.Date
    private String creator;
    private int isDelete;
}
