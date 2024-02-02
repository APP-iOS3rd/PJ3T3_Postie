# 📮 포스티 - Postie
|<img height="120" src="https://github.com/APP-iOS3rd/PJ3T3_Postie/assets/106911494/48ce95b8-ba6e-4fc1-846d-23fb2d80fe1e">|관리하기 힘든 편지들, 앱에서 저장하고 언제 어디서나 한번에 확인해보세요!|
|---|---|

## 📮 목차
1. [소개](#소개)
2. [개발 환경 및 라이브러리](#개발-환경-및-라이브러리)
3. [기능 설명](#기능-설명)
4. [동작 원리](#동작-원리)
5. [타임라인](#타임라인)
6. [실행 화면](#실행-화면)
7. [트러블 슈팅](#트러블-슈팅)

## 📮 소개
### ✉️ 앱 목적
연인과 부모님과, 친구 또는 내 아이와 주고받은 편지를 이미지로 앱에 등록해 보관하고 꺼내 보아요.  
보관된 편지는 이미지 텍스트 인식을 통해 내용을 검색할 수도 있어요.  
지도에 표시된 우체통, 우체국 정보를 확인하여 쉽게 손글씨로 작성한 편지를 보낼 수 있어요.

### ✉️ 타겟 사용자

### ✉️ 팀원 소개
|  | <img height="120" width="120" src="https://avatars.githubusercontent.com/u/42514601?v=4"> | <img width="120" height="120" src="https://avatars.githubusercontent.com/u/102846055?v=4"> | <img height="120" width="120" src="https://avatars.githubusercontent.com/u/119300554?v=4"> | <img height="120" width="120" src="https://avatars.githubusercontent.com/u/123723493?v=4"> | <img height="120" width="120" src="https://avatars.githubusercontent.com/u/106911494?v=4"> |
|:-:|:-:|:-:|:-:|:-:|:-:|
| GitHub | [권운기](https://github.com/qlrmr111) | [권지원](https://github.com/wonny1012) | [김현진](https://github.com/hjsupernova) | [양주원](https://github.com/lm-loki/Im-loki) | [정은수](https://github.com/Eunice0927) |

## 📮 개발 환경 및 라이브러리

### ✉️ 개발 환경
- XCode 15.2
- Swift 5.9.2

### ✉️ 앱 타겟
- iOS 16.0

### ✉️ 라이브러리
|이름|버전|사용기술|
| :-: | :-: | --- |
| VisionKit | | - LiveText: 편지 이미지의 글자를 인식 |
| 우체국 API| |- 우체국 관련 API<br/>- 우체국 영업시간 제공|
| NaverMapApi |NMapsGeometry (1.0.1)<br/>NMapsMap (3.17.0)| - 우체국, 우체통 카테고리 필터링<br/>- 우체국, 우체통의 위치를 API에서 가져와 지도에 핀으로 표시<br/>- 클러스터링 |
| Firebase | 10.20.0 | - Authentication: Google, Apple 회원가입 및 로그인<br/>- Firestore Database: 로그인 해 저장한 편지 데이터 관리<br/>- Storage: 편지 이미지 관리 |
| SwiftUI | | - searchable: 초성 검색, 검색 결과에 하이라이트 |

## 📮 기능 설명

### ✉️ 홈 탭
|실행 화면|설명|
|---|---|
||- 저장한 편지 리스트를 보여줍니다.<br>&emsp;- 편지를 눌러 사진과 내용을 자세히 볼 수 있습니다.<br>&emsp;- 화면 우측 상단의 미트볼 아이콘을 눌러 저장된 편지를 편집하거나 삭제할 수 있습니다.<br>- 편지를 검색합니다. 검색어는 편지 내용, 보낸 사람, 받은 사람을 모두 포함합니다.<br>- 새 편지를 저장합니다.<br>&emsp;- 보낸 편지, 받은 편지를 Modal로 선택하여 저장할 수 있습니다.<br>&emsp;- 편지 작성자를 연락처에서 불러올 수 있습니다.<br>&emsp;- 편지를 작성하거나 받은 날짜를 지정할 수 있습니다.<br>&emsp;- 사진 촬영시 텍스트 스캔 모드와 이미지 촬영 모드를 선택할 수 있습니다.<br>&emsp;- AI를 활용해 편지 내용을 한줄로 요약할 수 있습니다.<br>&emsp;- 텍스트 스캔 결과와 편지 요약은 모두 사용자가 수정할 수 있습니다.|

### ✉️ 쇼핑 탭
|실행 화면|설명|
|---|---|
||- 테마로 구분된 편지지 이미지를 보여줍니다.<br/>- 이미지를 클릭하면 해당 편지지를 판매하는 사이트로 링크되는 Safari 창이 Modal로 나타납니다.|

### ✉️ 지도 탭
|실행 화면|설명|
|---|---|
||- 우체국 API를 사용해 우체국 위치와 우체통 위치를 보여줍니다.<br/>- 지도는 Naver 지도 API를 사용하며, 내 위치로 이동하거나 pinch zoom in-out을 사용할 수 있습니다.<br/>- 지도상의 pin 위치가 겹쳐지면 cluster됩니다.|

### ✉️ 설정 메뉴
|실행 화면|설명|
|---|---|
||- 화면 우측 상단의 햄버거 아이콘으로 진입합니다.<br/>- 로그인에 활용한 API의 이름, 이메일, 프로필사진을 가져옵니다.<br/>- 계정 관리 및 다크모드를 지원합니다.|

## 📮 동작 원리

### ✉️ 아키텍처

### ✉️ 흐름도

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
    - Cloud Messeging 기능 추가 구현
    - 홈뷰 UI 수정
    - 느린 우체통 기능 추가 구현
- 발표 준비 및 발표(3일)
    - 기간: 2024.02.26 ~ 2024.02.28

## 📮 실행 화면

## 📮 트러블 슈팅

### ✉️ 문제 제목

1. 문제 정의
2. 사실 수집
3. 원인 추론
4. 조사 방법 결정
5. 조사 내용 구현
6. 결과 관찰

## 📮 폴더 트리

```swift
📦PJ3T3_Postie
 ┣ 📂App
 ┃ ┗ 📜PJ3T3_PostieApp.swift
 ┣ 📂Components
 ┣ 📂Core
 ┃ ┣ 📂Home
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜AddLetterView.swift
 ┃ ┃ ┃ ┣ 📜HomeView.swift
 ┃ ┃ ┃ ┣ 📜LetterDetailView.swift
 ┃ ┃ ┃ ┣ 📜LetterImageFullScreenView.swift
 ┃ ┃ ┃ ┗ 📜UIImagePicker.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┣ 📜AddLetterViewModel.swift
 ┃ ┃ ┃ ┣ 📜FirestoreManager.swift
 ┃ ┃ ┃ ┣ 📜HomeViewModel.swift
 ┃ ┃ ┃ ┣ 📜StorageManager.swift
 ┃ ┃ ┃ ┗ 📜TextRecognizer.swift
 ┃ ┣ 📂Login
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜LoginInputView.swift
 ┃ ┃ ┃ ┣ 📜LoginView.swift
 ┃ ┃ ┃ ┗ 📜RegistrationView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜AuthViewModel.swift
 ┃ ┣ 📂Map
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜MapCoordinator.swift
 ┃ ┃ ┃ ┗ 📜MapView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┣ 📜MapApi.swift
 ┃ ┃ ┃ ┗ 📜MapViewModel.swift
 ┃ ┣ 📂Root
 ┃ ┃ ┗ 📜ContentView.swift
 ┃ ┣ 📂Setting
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📜SettingView.swift
 ┃ ┃ ┃ ┗ 📜SettingsRowView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜SettingViewModel.swift
 ┃ ┗ 📂Shop
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📜ShopView.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┃ ┗ 📜ShopViewModel.swift
 ┣ 📂Extenstions
 ┃ ┗ 📜Color.swift
 ┣ 📂Model
 ┃ ┣ 📜Letter.swift
 ┃ ┗ 📜User.swift
 ┣ 📂Preview Content
 ┃ ┗ 📂Preview Assets.xcassets
 ┃ ┃ ┗ 📜Contents.json
 ┣ 📂Assets.xcassets
 ┣ 📜.DS_Store
 ┗ 📜GoogleService-Info.plist
```
