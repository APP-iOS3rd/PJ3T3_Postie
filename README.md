# 📮 포스티 - Postie
|<img height="120" alt="앱 아이콘" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/56d8fad1-3821-4f64-a62a-f14550c3a835">|손으로 쓴 감동, 내 손안의 편지보관함|
|---|---|

## 📮 목차
1. [소개](#소개)
2. [개발 환경 및 라이브러리](#개발-환경-및-라이브러리)
3. [실행 화면](#실행-화면)
4. [기능 설명](#기능-설명)
5. [동작 원리](#동작-원리)
6. [타임라인](#타임라인)
7. [기대 효과](#기대-효과)
8. [프로젝트를 마무리하며](#프로젝트를-마무리하며)

## 📮 소개
### ✉️ 앱 목적
잃어버렸거나 잊혔거나 여기저기 흩어져 있는 편지들<br>
또는 친구에게 전달하여 더 이상 읽을 수 없는 편지까지<br>
편지 내용과 편지지, 편지 봉투까지 저장해 언제, 어디서나 앱에서 꺼내 보세요<br>

### ✉️ 앱 스토어([링크](https://apps.apple.com/kr/app/%ED%8F%AC%EC%8A%A4%ED%8B%B0-postie/id6478052812))
<img width="185" alt="앱스토어 이미지1" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/18e3bfb6-110c-4a2a-b2f5-456009448ffc">
<img width="185" alt="앱스토어 이미지2" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/25c0dcc7-bf7e-48ce-8291-a0790082df26">
<img width="185" alt="앱스토어 이미지3" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/332a439c-ece3-479b-b357-401021f41dfb">
<img width="185" alt="앱스토어 이미지4" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/35f7929c-bc6f-4045-8d57-e87ef96dc744">
<img width="185" alt="앱스토어 이미지5" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/ad8d1a6c-e1fd-4de1-9da3-0b5703c7abae">


### ✉️ 팀원 소개
|  | <img height="120" width="120" alt="권운기프로필이미지" src="https://avatars.githubusercontent.com/u/42514601?v=4"> | <img width="120" height="120" alt="권지원프로필이미지" src="https://avatars.githubusercontent.com/u/102846055?v=4"> | <img height="120" width="120" alt="김현진프로필이미지" src="https://avatars.githubusercontent.com/u/119300554?v=4"> | <img height="120" width="120" alt="양주원프로필이미지" src="https://avatars.githubusercontent.com/u/123723493?v=4"> | <img height="120" width="120" alt="정은수프로필이미지" src="https://avatars.githubusercontent.com/u/106911494?v=4"> |
|:-:|:-:|:-:|:-:|:-:|:-:|
| GitHub | [권운기](https://github.com/qlrmr111) | [권지원](https://github.com/wonny1012) | [김현진](https://github.com/hjsupernova) | [양주원](https://github.com/lm-loki/Im-loki) | [정은수](https://github.com/Eunice0927) |

## 📮 개발 환경 및 라이브러리

### ✉️ 개발 환경
- XCode 15.2
- Swift 5.9.2

### ✉️ 앱 타겟
- iOS 16.0

### ✉️ 협업 도구
|<img width="50" alt="github" src = "https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/e39fd54b-74f9-457e-8c13-57f5a76fef64">|<img width="50" alt="notion" src = "https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/a0b5e028-2527-4663-bc09-c9f074571fd8">|<img width="50" alt="figma" src = "https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/56f00f01-1b99-40db-8508-a26e8e64d5de">|<img width="50" alt="discord" src = "https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/e9dab78a-8361-481a-b357-4864295b0b5b">|<img width="60" alt="procreate" src = "https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/4b2ecdb1-f075-462a-b052-4c96d5e4804e">|
|---|---|---|---|---|

### ✉️ 라이브러리
|이름|버전|사용기술|
| :-: | :-: | --- |
| Vision | | 편지 이미지의 글자를 인식 |
| Clova | | AI로 편지 내용 한 줄 요약 |
| 우체국 API| |- 우체국 관련 API<br/>- 우체국 영업시간 제공|
| NaverMapApi |NMapsGeometry (1.0.1)<br/>NMapsMap (3.17.0)| - 우체국, 우체통 카테고리 필터링<br/>- 우체국, 우체통의 위치를 API에서 가져와 지도에 핀으로 표시<br/>- 지도 위에 검색 반경 표시 |
| Firebase | 10.20.0 | - Authentication: Google, Apple 회원가입 및 로그인<br/>- Firestore Database: 로그인 해 저장한 편지 데이터 관리<br/>- Storage: 편지 이미지 관리 |
| Kingfisher | | 편지 이미지와 편지지 쇼핑몰의 이미지를 비동기로 로딩하고 캐시 관리 |
| SwiftUI | | - searchable: 초성 검색, 검색 결과에 하이라이트<br>-SafariService로 사용자가 외부에서 편지지를 쉽게 구매할 수 있도록 함<br>- UserNotifications로 느린 우체통의 편지 알림|

## 📮 실행 화면
### ✉️ 포스티 시작하기
|스크린샷|스크린샷|스크린샷|
|:-:|:-:|:-:|
|<img width="200" alt="런치스크린" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/dbdebec5-e11e-43e9-a619-86184d793922">|<img width="200" alt="로그인" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/55160e6f-102a-42ef-ac61-62d68879c76e">|<img width="200" alt="닉네임 생성" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/f4ed98e4-06f2-4e83-991f-9c17d845d421">|

### ✉️ 편지 보관하기
|영상|영상|스크린샷|
|:-:|:-:|:-:|
|<img width="200" alt="편지 보관 영상" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/6b4dd189-6a60-4294-be68-248d19df8bb6">|<img width="200" alt="편지 보관 영상" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/0207b2b3-b1f9-42f5-a25d-2b24d041ea59">||
|<img width="200" alt="편지보관탭" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/50f89e27-30ea-4e22-b0a9-0e5b6ee1509f">|<img width="200" alt="보낸편지보관" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/b94e98ba-2ffc-46b6-98be-e207db9dfc6c">|<img width="200" alt="받은편지보관" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/22984412-b14c-4a31-9148-cce3e505813d">|

### ✉️ 편지 찾기
|영상|스크린샷|스크린샷|스크린샷|
|:-:|:-:|:-:|:-:|
|<img width="200" alt="편지검색" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/be3a74d3-76d6-4029-b7e3-dbb2e31990e1">|<img width="200" alt="검색성공" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/1061089a-2024-4abc-9469-90b047a68a3f">|<img width="200" alt="검색어없음" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/b1f2711b-73f1-4eb4-86c9-1955e0a2bc60">|<img width="200" alt="검색실패" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/9386df42-3452-4821-883e-a83bbc33e4a5">|

### ✉️ 우체국, 우체통 찾기
|영상|영상|스크린샷|
|:-:|:-:|:-:|
|<img width="200" alt="우체국" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/f66f2fbc-ee95-408a-8a78-3b99c1005fda">|<img width="200" alt="우체통" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/212e1b42-20be-4e14-9791-f6f997ce0465">|<img width="200" alt="지도검색" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/8e42627d-edb8-4655-9cde-0347a41cfc5e">|
|<img width="200" alt="우체국" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/3f517d09-3f87-4ae8-a906-42f466c7666f">|<img width="200" alt="우체통" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/ccab28f4-a076-4362-b0f4-e5cb8de3173f">||

### ✉️ 편지지 구매하기
|영상|스크린샷|
|:-:|:-:|
|<img width="200" alt="편지지구매" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/bbf8e065-97f7-408a-9a99-9d7e8bbecf37">|<img width="200" alt="편지지" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/bbe5329b-708a-48f7-836e-e3f0f565755c">|

### ✉️ 느린 우체통
|영상|영상|스크린샷|
|:-:|:-:|:-:|
|<img width="200" alt="느린우체통저장" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/f31dc501-4545-4454-9f21-348f1c2cb11b">|<img width="200" alt="느린우체통알림" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/3168768c-d12f-4199-93ff-d9b1aaba05a2">|<img width="200" alt="느린우체통" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/429ca8a0-4a89-45c0-b600-68477d04b8ed">|

### ✉️ 부가기능
|영상|영상|스크린샷|스크린샷|
|:-:|:-:|:-:|:-:|
|<img width="200" alt="테마" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/47a8891b-692e-4cf2-bce8-e471f4859d55">|<img width="200" alt="정렬" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/039ab5cb-0ad2-4abe-8607-7e0853597383">|||
|<img width="180" alt="사이드메뉴" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/d516217f-eaf6-48c7-9b0c-34fad58ef810">|<img width="180" alt="프로필" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/c521a921-aeb4-44e9-9e15-978cfda28214">|<img width="180" alt="테마" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/1195f87a-cdaf-4c6c-8ed4-71e3658ac64f">|<img width="180" alt="정렬" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/3afca429-b8c5-4aeb-876f-2b9e1f40fe84">|
|<img width="180" alt="알림" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/bae38326-d1b7-4a14-9f91-4a97380b7c78">|<img width="180" alt="공지" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/00cdb0fb-c33b-4c17-83a2-e999136b79d2">|<img width="180" alt="문의" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/8bd81df6-4bfb-4371-bd89-e81c1cd53fa4">|<img width="180" alt="앱정보" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/16b3cb9d-b289-408e-9268-d99b66d47346">|

## 📮 기능 설명

### ✉️ 홈 탭
|실행 화면|설명|
|---|---|
||- 새 편지를 저장합니다.<br>&emsp;- 보낸 편지, 받은 편지를 구분하여 저장할 수 있습니다.<br>&emsp;- 편지를 작성하거나 받은 날짜를 지정할 수 있습니다.<br>&emsp;- 사진 촬영을 촬영하면 자동으로 텍스트가 인식됩니다.<br>&emsp;- Naver Clova AI를 활용해 편지 내용을 한줄로 요약할 수 있습니다.<br>&emsp;- 텍스트 스캔 결과와 편지 요약은 모두 사용자가 수정할 수 있습니다.<br>- 저장한 편지 리스트를 보여줍니다.<br>&emsp;- 편지를 눌러 사진과 내용을 자세히 볼 수 있습니다.<br>&emsp;- 화면 우측 상단의 미트볼 아이콘을 눌러 저장된 편지를 편집하거나 삭제할 수 있습니다.<br>- 편지를 검색합니다. 검색어는 편지 내용과 한줄 요약을 포함합니다.|

### ✉️ 쇼핑 탭
|실행 화면|설명|
|---|---|
||- 테마로 구분된 편지지 이미지를 보여줍니다.<br/>- 이미지를 클릭하면 해당 편지지를 판매하는 사이트로 링크되는 Safari 창이 Modal로 나타납니다.|

### ✉️ 지도 탭
|실행 화면|설명|
|---|---|
||- 우체국 API를 사용해 우체국 위치와 우체통 위치와 영업시간을 보여줍니다.<br/>- 지도는 Naver 지도 API를 사용하며, 내 위치로 이동하거나 원하는 지역을 검색할 수 있습니다.<br/>- 지도상에 현재 검색 가능한 위치 반경을 원으로 그려줍니다.|

### ✉️ 설정 메뉴
|실행 화면|설명|
|---|---|
||- 화면 우측 상단의 햄버거 아이콘으로 진입합니다.<br/>- 로그인에 활용한 API의 이름, 이메일, 프로필사진을 가져옵니다.<br/>- 계정 관리 및 테마를 지원합니다.|

## 📮 동작 원리

### ✉️ 프로젝트 아키텍처
<img height="200" alt="architecture" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/1ab2aadb-6fab-4b59-9cff-e64c6781bf35">

### ✉️ 데이터베이스 설계
<img height="350" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/53c1a326-fd7b-47df-a656-7b1020566a80">

## 📮 타임라인
> 프로젝트 총 기간: 2023.12.21 ~ 2024.02.28 (2개월)

- 아이디어 선정 (약 1주)
    - 기간: 2023.12.21 ~ 2023.12.29
    - 팀 빌딩
    - 아이디어 회의
- 프로젝트 사전 준비 (약 1주)
    - 기간: 2024.01.02 ~ 2024.01.10
    - 팀 규칙, PR 규칙 및 코딩 컨벤션 선정
    - UI 브레인 스토밍 및 필요 기술 선정
    - 선정된 기술에 대하여 구현 가능 여부 사전 스터디
    - 우체국 API 사용 신청
- 개발 기간 1 (2주)
    - 기간: 2024.01.11 ~ 2024.01.24
    - 피그마 디자인 제작
    - 지도 API 연결
    - 우체국 API XML로 받아와 지도에 위치 표시
    - 로그인 뷰 UI 구현 및 Firebase Authentication 연결
    - 홈, 상세화면 뷰 UI 구현 및 Firestore Database 연결
    - 편지 저장 뷰 UI 구현 및 OCR, 텍스트 요약 API, Firebase Storage 연결
    - 쇼핑몰 뷰 구현 및 SFSafariView 연결
- 재정비 (2일)
    - 피그마 디자인 수정
    - 유저 피드백을 위한 설문조사 제작 및 진행
    - 추가 개발 사항 선정
- 개발 기간 2 (4주)
    - 기간: 2024.01.29 ~ 2024.02.25
    - Social 로그인 기능 완성
    - 로컬 푸시 기능 추가 구현
    - 모든 뷰 고도화 작업
    - 느린 우체통 기능 추가 구현
- 발표 준비 및 발표(3일)
    - 기간: 2024.02.26 ~ 2024.02.28

## 📮 기대 효과
### ✉️ 사용자
- 편리함과 효율성 제고
- 디지털 시대의 소통에 따뜻함 추가
  - 이메일과 인스턴트 메시징이 지배하는 현대사회에, 느린 우체통 기능은 소통에 따뜻함과 의미를 더함
- 개인적인 소통의 부활
  - 자신의 생각과 감정을 글로 표현하는 데 더 많은 시간을 할애하게 되며, 다른 사람들과의 관계를 강화
  - 디지털 네이티브 세대에게 과거의 소통 방식을 경험할 기회를 제공

### ✉️ 개발자
- 리팩토링의 중요성 학습
- 설문조사 및 유저 테스트의 필요성 인지
- 체력과 건강이 프로젝트의 성공에 중요함을 인지
- 결과물을 내기까지 기획, 디자인과 같은 과정을 거치며 많은 의사결정이 필요함을 학습
- 거시적 일정관리의 필요성을 학습

## 📮 프로젝트를 마무리하며
### ✉️ 추가 개발 예정 기능
- 앱 잠금 서비스
- 받은 편지에 대한 개인적인 마음과 감정을 담을 수 있는 편지 메모란을 앱에 추가
- 라디오 사연처럼 모든 사용자에게 공개되는 편지를 받는 기능을 도입하여, 사용자들 간에 긍정적인 에너지를 공유

### ✉️ 향후 프로젝트 방향과 계획
**월 2회 온오프라인 미팅을 통한 추가 기능 개발 및 유지보수**

- 사용자 피드백 수집 및 적극 반영: 사용자들의 요구를 충족시키고 사용자 경험을 개선하기위해 노력
- 기술적 업그레이드: 새로운 기술이나 프레임워크를 도입하여 성능을 향상시키고 사용자들에게 더 나은 서비스를 제공
- 유지보수: 리팩토링, 코드 최적화, 부가기능 추가

### ✉️ 개발하며 얻은 교훈
- 처음에는 되는대로 개발을 했는데, 프로젝트를 진행하면서 코드 양이 많아지다 보니 내가 적은 코드도 나중에 보면 읽기 힘들어졌습니다. 이를 통해 코드 리팩토링의 중요함을 깨달았습니다.
- 설문조사와 유저 테스트를 통해 다양한 사용자 니즈를 파악했고, 예상과 다른 행동에서 다양한 인사이트를 얻었습니다. 이를 통해 사용자와의 의사소통의 중요함을 깨달았습니다.
- 프로젝트의 성공을 위해서는 개발뿐만 아니라 본인과 팀원들의 건강도 중요하다는 것을 깨달았습니다.
- 단순히 코드 개발만 하는 게 아닌 세세한 앱 디자인부터 발표까지, 다양한 계획들에 대한 토론의 중요성을 알게 되었습니다.
- 기능 명세서나 Git Issue와 같은 프로젝트 관리 도구를 사용하여 일정을 대부분 일간 Task 같이 작은 단위로 관리했는데, 결과물을 목표한 대로 만들기 위해서는 거시적 관점에서 일정 관리를 하는 것도 필요하다는 것을 알게 되었습니다.

## 📮 폴더 트리

```
📦PJ3T3_Postie
 ┣ 📂App
 ┃ ┗ 📜PJ3T3_PostieApp.swift
 ┣ 📂Assets.xcassets
 ┣ 📂Components
 ┃ ┣ 📜Button.swift
 ┃ ┣ 📜ClearBackground.swift
 ┃ ┗ 📜LoadingView.swift
 ┣ 📂Core
 ┃ ┣ 📂Home
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜AddLetterView.swift
 ┃ ┃ ┃ ┣ 📜EditLetterView.swift
 ┃ ┃ ┃ ┣ 📜GroupedFavoriteListLetterView.swift
 ┃ ┃ ┃ ┣ 📜GroupedLetterView.swift
 ┃ ┃ ┃ ┣ 📜GroupedListLetterView.swift
 ┃ ┃ ┃ ┣ 📜GroupedMyListLetterView.swift
 ┃ ┃ ┃ ┣ 📜HomeView.swift
 ┃ ┃ ┃ ┣ 📜LetterDetailView.swift
 ┃ ┃ ┃ ┣ 📜LetterImageFullScreenView.swift
 ┃ ┃ ┃ ┣ 📜ListLetterView.swift
 ┃ ┃ ┃ ┣ 📜PageViewController.swift
 ┃ ┃ ┃ ┣ 📜SearchView.swift
 ┃ ┃ ┃ ┣ 📜SlowPostBoxView.swift
 ┃ ┃ ┃ ┗ 📜UIImagePicker.swift
 ┃ ┃ ┣ 📂ViewModel
 ┃ ┃ ┃ ┣ 📜AddLetterViewModel.swift
 ┃ ┃ ┃ ┣ 📜EditLetterViewModel.swift
 ┃ ┃ ┃ ┣ 📜GroupedLetterViewModel.swift
 ┃ ┃ ┃ ┣ 📜HomeViewModel.swift
 ┃ ┃ ┃ ┣ 📜LetterDetailViewModel.swift
 ┃ ┃ ┃ ┣ 📜SlowPostBoxViewModel.swift
 ┃ ┃ ┃ ┣ 📜SummaryApi.swift
 ┃ ┃ ┃ ┗ 📜TextRecognizer.swift
 ┃ ┃ ┗ 📜SummaryApiKeys.plist
 ┃ ┣ 📂Login
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜DeleteAccountButtonView.swift
 ┃ ┃ ┃ ┣ 📜EmailLoginView.swift
 ┃ ┃ ┃ ┣ 📜LoginInputView.swift
 ┃ ┃ ┃ ┣ 📜LoginView.swift
 ┃ ┃ ┃ ┣ 📜NicknameView.swift
 ┃ ┃ ┃ ┣ 📜ReAuthButtonView.swift
 ┃ ┃ ┃ ┗ 📜RegistrationView.swift
 ┃ ┣ 📂Map
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜CoordinaterEtc.swift
 ┃ ┃ ┃ ┣ 📜Coordinator.swift
 ┃ ┃ ┃ ┣ 📜MapCoordinator.swift
 ┃ ┃ ┃ ┗ 📜MapView.swift
 ┃ ┃ ┣ 📂ViewModel
 ┃ ┃ ┃ ┣ 📜LocationManager.swift
 ┃ ┃ ┃ ┣ 📜MapApi.swift
 ┃ ┃ ┃ ┣ 📜MapViewModel.swift
 ┃ ┃ ┃ ┣ 📜MyCoord.swift
 ┃ ┃ ┃ ┗ 📜NaverMap.swift
 ┃ ┃ ┗ 📜MapApiKeys.plist
 ┃ ┣ 📂Root
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📜ContentView.swift
 ┃ ┃ ┣ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜ContenViewModel.swift
 ┃ ┃ ┗ 📜ContentView.swift
 ┃ ┣ 📂Setting
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜AlertView.swift
 ┃ ┃ ┃ ┣ 📜FirebaseTestRowView.swift
 ┃ ┃ ┃ ┣ 📜FirebaseTestView.swift
 ┃ ┃ ┃ ┣ 📜InformationView.swift
 ┃ ┃ ┃ ┣ 📜InformationWebView.swift
 ┃ ┃ ┃ ┣ 📜MembershipView.swift
 ┃ ┃ ┃ ┣ 📜NoticeView.swift
 ┃ ┃ ┃ ┣ 📜ProfileEditView.swift
 ┃ ┃ ┃ ┣ 📜ProfileView.swift
 ┃ ┃ ┃ ┣ 📜QuestionView.swift
 ┃ ┃ ┃ ┣ 📜SplashScreenView.swift
 ┃ ┃ ┃ ┗ 📜ThemeView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜SettingViewModel.swift
 ┃ ┣ 📂Shop
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📜ShopView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜ShopViewModel.swift
 ┣ 📂Extenstions
 ┃ ┣ 📜Color.swift
 ┃ ┣ 📜Date.swift
 ┃ ┣ 📜EnvironmentValues.swift
 ┃ ┣ 📜Font.swift
 ┃ ┣ 📜Logger.swift
 ┃ ┣ 📜String.swift
 ┃ ┗ 📜View.swift
 ┣ 📂Font
 ┃ ┣ 📜NanumMyeongjo.otf
 ┃ ┣ 📜NanumMyeongjoBold.otf
 ┃ ┣ 📜SairaStencilOne-Regular.ttf
 ┃ ┣ 📜SourceSerifPro-Black.otf
 ┃ ┗ 📜SourceSerifPro-Light.otf
 ┣ 📂Manager
 ┃ ┣ 📜AppStoreUpdateChecker.swift
 ┃ ┣ 📜AppleSignInHelper.swift
 ┃ ┣ 📜AuthCaseHelper.swift
 ┃ ┣ 📜AuthManager.swift
 ┃ ┣ 📜CryptoUtils.swift
 ┃ ┣ 📜FirestoreManager.swift
 ┃ ┣ 📜FirestoreNoticeManager.swift
 ┃ ┣ 📜FirestoreShopManager.swift
 ┃ ┣ 📜GoogleSignInHelper.swift
 ┃ ┣ 📜NotificationManager.swift
 ┃ ┗ 📜StorageManager.swift
 ┣ 📂Model
 ┃ ┣ 📜AppleUser.swift
 ┃ ┣ 📜GoogleUser.swift
 ┃ ┣ 📜Letter.swift
 ┃ ┣ 📜LetterPhoto.swift
 ┃ ┣ 📜OfficialLetter.swift
 ┃ ┣ 📜PostieUser.swift
 ┃ ┗ 📜Shop.swift
 ┣ 📂Preview Content
 ┃ ┗ 📂Preview Assets.xcassets
 ┣ 📜.DS_Store
 ┣ 📜GoogleService-Info.plist
 ┗ 📜PJ3T3_Postie.entitlements
```
