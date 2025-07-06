# SwiftUISamples
## 이 프로젝트는?
SwiftUI 샘플입니다.
SwiftUIのサンプルです。

## 주요 기능들
  - 각종 페이지 이동/표시
    - Sheet 표시. 밑에서 나오고 위 부분이 조금만 남습니다.
    - Full Scleen 표시. 화면 전체를 이용해 새로운 페이지를 표시합니다.
    - @EnvironmentObject를 이용한 화면 내 뷰 표시. 같은 화면 내에서 표시합니다.
  - Arkana를 이용한 APIKey 숨기기
    - 기밀 정보를 난독화할 수 있는 Arkana를 이용해봤습니다. https://github.com/rogerluan/arkana
  - Alamofire를 이용한 API 연결
    - HTTP 네트워킹 라이브러리 Alamofire를 이용한 서버 통신 샘플입니다. https://github.com/Alamofire/Alamofire
  - Notion API 연동
    - Notion Database 내용을 표시하는 샘플입니다. https://developers.notion.com/

## UI 샘플
  - 버튼
    - 배경색 등 각종 설정을 부여한 버튼입니다. ButtonStyle를 화면전체(VStack)에 적용했습니다.
    - ![iOS.png](https://github.com/kobataAyaka/SwiftUISamples/blob/images/ButtonStyle.png)
  - 그라데이션이 부여된 쉐도우
    - View Modifier로 작성해서 모든 뷰에서 이용가능합니다.
    - ![iOS.png](https://github.com/kobataAyaka/SwiftUISamples/blob/images/Simulator%20Screenshot%20-%20iPhone%20SE%20(3rd%20generation)%20-%202024-11-21%20at%2014.10.50.png)

## Swift Concurrency (async/await)
  - Alamofire 5.5부터 지원하는 방법입니다. https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#using-alamofire-with-swift-concurrency
  - 5.5 이전에서는 withCheckedThrowingContinuation를 이용했었습니다.

## 다언어화
  - 다언어 지원
    - 한국어, 일본어, 영어를 지원합니다.
    - 처음에 디바이스 설정을 가져온 뒤, 앱 내에서도 변경이 가능합니다.
    - String Catalog를 이용합니다. 위부 번역팀과 쉽게 협업할 수 있습니다.
   
    - https://github.com/user-attachments/assets/fcf0aa1a-e866-49e4-9ca6-4060f5966795

