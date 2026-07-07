package com.wjh.quest.controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;

@RestController
public class QRCodeController {

    /**
     * 生成二维码图片API
     * @param content 要编码的内容（URL或文本）
     * @param width 二维码宽度（可选，默认200）
     * @param height 二维码高度（可选，默认200）
     * @param response HTTP响应对象
     * @throws Exception 可能抛出IO或二维码生成异常
     */
    @GetMapping("/api/qrcode")
    public void generateQRCode(
            @RequestParam String content,
            @RequestParam(required = false, defaultValue = "200") int width,
            @RequestParam(required = false, defaultValue = "200") int height,
            HttpServletResponse response) throws Exception {

        // 设置响应类型为PNG图片
        response.setContentType("image/png");

        // 获取输出流
        try (OutputStream outputStream = response.getOutputStream()) {
            // 创建QRCodeWriter实例
            QRCodeWriter qrCodeWriter = new QRCodeWriter();

            // 生成二维码矩阵
            BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height);

            // 将矩阵写入输出流
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);

            // 刷新输出流
            outputStream.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("生成二维码失败: " + e.getMessage());
        }
    }
}
