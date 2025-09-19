# 펫밀리 (Petmily)

반려동물 용품 쇼핑몰 프로젝트 🐶🐱  

## 📌 프로젝트 개요
Spring MVC와 MySQL 기반의 반려동물 쇼핑몰 웹 애플리케이션입니다.  
상품 관리, 회원 관리, 게시판, 장바구니 및 결제 기능을 제공합니다.  
또한 날씨 API와 공공데이터 API를 활용하여 추천 상품과 동물병원 정보를 제공합니다.

## 🛠 기술 스택
- Java 17
- Spring MVC, MyBatis
- Maven
- MySQL
- JSP, JSTL, HTML/CSS/JS
- Tomcat 9

## 📊 ERD
(ERD 이미지 첨부)

## ✨ 주요 기능
- 회원 CRUD
- 상품 CRUD 및 검색
- 게시판 CRUD (공지사항, 자유게시판, QnA)
- 장바구니 및 결제
- 날씨 API 기반 상품 추천
- 공공데이터 API 기반 전국 동물병원/약국 정보 제공

## 🚀 실행 방법
```bash
git clone https://github.com/ziapark/petmily.git
cd petmily
mvn clean package
