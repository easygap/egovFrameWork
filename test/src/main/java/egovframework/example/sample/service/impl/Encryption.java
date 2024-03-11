package egovframework.example.sample.service.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Description : 비밀번호 SHA-256 방식 암호화
 * 작성일 : 2024.03.11
 * 작성자 : ljs
 * Input Argument:
 *      1) md : SHA-256 알고리즘 지정
 */
public class Encryption {

	public String encrypt(String text) throws NoSuchAlgorithmException{
		/** MessageDigest 클래스의 getInstance() 메소드의 매개변수에 "SHA-256" 알고리즘 이름을 지정함으로써 
		해당 알고리즘에서 해시값을 계산하는 MessageDigest를 구할 수 있다 */
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(text.getBytes());    // 데이터(패스워드 평문)를 한다. 즉 '암호화'와 유사한 개념

        return bytesToHex(md.digest());    // 바이트 배열로 해쉬를 반환한다.
    }

    private String bytesToHex(byte[] bytes){
        StringBuilder builder = new StringBuilder();
        for(byte b : bytes){    // 256비트로 생성 => 32Byte => 1Byte(8bit) => 16진수 2자리로 변환 => 16진수 한 자리는 4bit
            builder.append(String.format("%02x", b));
        }
        return builder.toString();
    }
}