package com.petmillie.member.service;

import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service("mailService")
public class MailServiceImpl implements MailService{
	@Autowired
	private JavaMailSender mailSender;
	private int authNumber;
	
	public void makeRandomNumber() {
		Random r = new Random();
		int checkNum = r.nextInt(888888) + 111111;
		System.out.println("인증번호: " + checkNum);
		authNumber = checkNum;
	}
	
	public String joinEmail(String email) {
		makeRandomNumber();
        String setFrom = "devPark320@gmail.com";
        String toMail = email;
        String title = "[펫밀리] 회원가입 인증 이메일 입니다.";
        String content = 
                "펫밀리 홈페이지를 방문해주셔서 감사합니다." +
                "<br><br>" + 
                "인증 번호는 " + authNumber + "입니다." + 
                "<br>" + 
                "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);
            // true는 html을 사용하겠다는 의미
            helper.setText(content, true);
            mailSender.send(message);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return Integer.toString(authNumber);
    }
}
