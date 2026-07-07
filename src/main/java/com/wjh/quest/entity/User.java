package com.wjh.quest.entity;

import lombok.Data;

@Data
public class User {
    private long id;
    private String username;
    private String password;
    private String phone;
    private int status;
}