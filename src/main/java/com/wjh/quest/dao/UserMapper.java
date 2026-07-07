package com.wjh.quest.dao;

import com.wjh.quest.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    User login(User user);

    User findByUsername(String username);

    int register(User user);
}
