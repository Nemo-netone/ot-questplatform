package com.wjh.quest.service;

import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
public class RedisService {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;


    /**
     * 保存key-Object信息
     *
     * @param key
     * @param object
     */
    public void putValue(String key, Object object) {
        stringRedisTemplate.opsForValue().set(key, JSONObject.toJSONString(object));
    }

    /**
     * 保存Key-Object信息，并制定time为失效时间
     *
     * @param key
     * @param object
     * @param time  单位为秒
     */
    public void putValue(String key, Object object, long time) {
        stringRedisTemplate.opsForValue().set(key, JSONObject.toJSONString(object), time, TimeUnit.SECONDS);
    }

    /**
     * 获取指定key的值
     *
     * @param key
     */
    public String getValue(String key) {
        return stringRedisTemplate.opsForValue().get(key);
    }

    /**
     * 删除指定key对应的信息
     *
     * @param key
     */
    public void deleteValue(String key) {
        stringRedisTemplate.delete(key);
    }

    /**
     * 获取指定key的信息，并转化为指定对象
     *
     * @param key
     * @return
     */
    public <T> T getValue(String key, Class<T> value) {
        return JSONObject.parseObject(stringRedisTemplate.opsForValue().get(key), value);
    }

    /**
     * 更新指定key的失效时间，单位设置为秒
     *
     * @param key
     * @param time
     */
    public void updateExpireTime(String key, long time) {
        stringRedisTemplate.expire(key, time, TimeUnit.SECONDS);
    }
}
