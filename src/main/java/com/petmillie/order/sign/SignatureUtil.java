package com.petmillie.order.sign;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class SignatureUtil {
    public static String makeSignature(String mid, String oid, String price, String timestamp, String signKey) {
        try {
            String data = "oid=" + oid + "&price=" + price + "&timestamp=" + timestamp + "&mid=" + mid;
            SecretKeySpec key = new SecretKeySpec(signKey.getBytes("UTF-8"), "HmacSHA256");
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(key);
            byte[] hmacData = mac.doFinal(data.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hmacData) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Signature generation failed", e);
        }
    }
}


