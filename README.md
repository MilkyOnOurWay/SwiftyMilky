![header](https://capsule-render.vercel.app/api?type=Soft&color=gradient&height=150&section=header&text=SwiftyMilky&fontSize=70&animation=twinkling)

</br>
</br>

# 🍎 밀키웨이 아요 멤 - 바를 소개합니다 🍎

</br>

|                            💛이윤진💛                            |                            이소영                            | 박유진 |
| :----------------------------------------------------------: | :----------------------------------------------------------: | ------ |
| <img src="https://images.velog.io/images/sso0022/post/b6ad88b5-f18a-4d61-8df8-3364c6688feb/KakaoTalk_Photo_2020-12-28-02-51-04.jpeg" height="300" /> | <img src="https://images.velog.io/images/sso0022/post/8276334a-92f7-4747-bcb9-f428956f58f5/IMG_9679%20%E1%84%87%E1%85%A9%E1%86%A8%E1%84%89%E1%85%A1%E1%84%87%E1%85%A9%E1%86%AB%202.JPG" height="300" /> |        |

</br>
</br>

# 🧸 Commit Message

</br>

> 우리는 깃모지를 활용해요

* 🎨  추가된 기능이 있을 때 

* ⚡️ 같은 동작을 하지만 코드를 개선시켰을 때

* 🔥 이전에 작성했던 코드를 지웠을 때 

* 🔀 merge 할 때 

* 🚀  etc

* 💄 UI 수정

</br>
</br>

# 🛠 Coding Convention 
</br>

<img src="https://user-images.githubusercontent.com/68267763/103177619-7ee7b580-48bf-11eb-82eb-6c8d03f6e326.png" height="400" />


- IBOutlet 옆에 주석으로 어떤 버튼인지 같은 거 적어놓기 !!!
- **카멜케이스** 맞춰서 이름 정하기
- [styleshare guide](https://github.com/StyleShare/swift-style-guide) 참조해서 **더 정확하고 자세하게** 정해보자


</br>
</br>

# 📂 Project Structure

</br>

```
Milkyway // 전체적으로 공유하는 파일은 Global, 뷰 위주의 파일은 Screens
  |── Global  // 델리게이트파일 및 익스텐션 관리. 서버 모델 및 서비스 파일 정리
  │   |── Delegate
  │   │     │── SceneDelegate.swift
  │   │     └── AppDelegate.swift
  │   |── Enums  // 폰트 파일 연결
  │   │     └── Font+Enum.swift
  │   |── Extensions // 익스텐션 파일(약간 치트키 느낌)
  │   │     │── UITableView+Extension.swift
  │   │     └── UIView+Extension.swift
  │   |── Models // 서버 통신에 필요한 모델 파일 추가하기
  │   │     │── ....swift
  │   │     └── Model.swift
  │   ├── Resources 
  │   │     │── Assets.xcassets
  │   │     └── LaunchScreen.storyboard
  │   ├── Service // 서버 API 관리    
  │   │    └── APIConstants.swift
  │   └── Supporting Files 
  │         └── Info.plist
  |── Screens 
  │   └── View // 뷰 별로 파일을 만들어 줍니다(밑에 Home, Search 참조)
  │         ├── Cell // 테이블뷰랑 콜렉션뷰 셀 파일 , xib 파일 정리
  │         │     └── TableviewCell / CollectionviewCell.swift
  │         ├── Storyboards // 뷰 별 스토리보드 추가해주기
  │         │      └── View.storyboard
  │         └── ViewControllers
  │               └── ViewVC.swift
  |               └── Home
  |               └── Search
  |                   ......
  ├── Milkyway.xcdatamodeld/
  ├── Milkyway.xcworkspace/
  └── Milkyway.xcodeproj/
```

</br>
</br>

# 🍒 git - flow

<img src="https://user-images.githubusercontent.com/68267763/103177125-f9fa9d00-48ba-11eb-9197-d8d1d9844b3b.png" height="500" />


우리는 `git flow`를 활용해요 

</br>


  * [gitflow 코드 정리](https://velog.io/@sso0022/git-git-flow-%EC%A0%95%EB%A6%AC)

  * [gitflow에 대하여](https://woowabros.github.io/experience/2017/10/30/baemin-mobile-git-branch-strategy.html)

</br>
</br>

# 🥛 The way we work remotely ✨

</br>

* 기본적으로 1시부터 6시까지 게더로 출근 및 퇴근을 합니다 (야근 확률 높음)
* 가장 먼저 퇴근하는 사람이 퇴근할 때 다함께 마지막 회의를 합니다
* 회의를 하면서 각자 3 - 5분, 오늘 작성한 코드를 서로에게 설명해주는 시간을 가집니다
* 오늘 일하면서 힘들었거나 잘 안풀렸던 것이 있다면 **꼭 꼭** 공유하기 !!! 




</br>
</br>
