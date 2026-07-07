package com.wjh.quest.service;

import com.alibaba.fastjson.JSONObject;
import com.wjh.quest.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Objects;

@Service
public class AuthService {
    private static final String HMAC_ALGORITHM = "HmacSHA256";

    @Value("${app.auth.secret}")
    private String secret;

    @Value("${app.auth.token-ttl-seconds}")
    private long tokenTtlSeconds;

    public String issueToken(User user) {
        long expiresAt = System.currentTimeMillis() / 1000 + tokenTtlSeconds;

        JSONObject header = new JSONObject();
        header.put("alg", "HS256");
        header.put("typ", "JWT");

        JSONObject payload = new JSONObject();
        payload.put("sub", user.getUsername());
        payload.put("uid", user.getId());
        payload.put("exp", expiresAt);

        String unsignedToken = base64Url(header.toJSONString()) + "." + base64Url(payload.toJSONString());
        return unsignedToken + "." + sign(unsignedToken);
    }

    public String requireUsername(String authorizationHeader) {
        String username = getUsername(authorizationHeader);
        if (username == null) {
            throw new IllegalArgumentException("用户未登录!");
        }
        return username;
    }

    public String getUsername(String authorizationHeader) {
        String token = extractBearerToken(authorizationHeader);
        if (token == null) {
            return null;
        }

        String[] parts = token.split("\\.");
        if (parts.length != 3) {
            return null;
        }

        String unsignedToken = parts[0] + "." + parts[1];
        if (!Objects.equals(sign(unsignedToken), parts[2])) {
            return null;
        }

        JSONObject payload;
        try {
            payload = JSONObject.parseObject(new String(Base64.getUrlDecoder().decode(parts[1]), StandardCharsets.UTF_8));
        } catch (Exception e) {
            return null;
        }

        Long expiresAt = payload.getLong("exp");
        if (expiresAt == null || expiresAt < System.currentTimeMillis() / 1000) {
            return null;
        }
        return payload.getString("sub");
    }

    private String extractBearerToken(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return null;
        }
        return authorizationHeader.substring("Bearer ".length()).trim();
    }

    private String sign(String value) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException("Token签名失败", e);
        }
    }

    private String base64Url(String value) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }
}
