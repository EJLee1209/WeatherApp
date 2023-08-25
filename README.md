## Weather App

<img src="https://github.com/EJLee1209/WeatherApp/assets/101651909/6ed2cabd-7ab9-41f7-a9e1-bc3a20d183a9" width=180/> | <img src="https://github.com/EJLee1209/WeatherApp/assets/101651909/ee669706-140a-43c2-88fb-8427b8c1b9ef" width=180/>
---|---|

아이폰 기본 앱인 날씨 앱을 클론 코딩하는 토이 프로젝트입니다. <br>
현재 위치 또는 원하는 위치 기반의 날씨 예보를 확인할 수 있습니다. <br>

날씨 데이터는 Open Weather API를 사용했습니다. <br>
https://openweathermap.org/api

<br>

개발 기간 : 2023.08.13 ~ 2023.08.18 <br>

## 🛠 Development Environment

![Generic badge](https://img.shields.io/badge/iOS-15.0+-lightgrey.svg) ![Generic badge](https://img.shields.io/badge/Xcode-14.3.1-blue.svg) ![Generic badge](https://img.shields.io/badge/Swift-5.8.1-purple.svg)



## 💻 Skills & Tech Stack
- Swift
- UIKit
- RxSwift
- Snapkit
- MapKit
- CoreData
- URLSession
- MVVM-C

## 👨‍💻 프로젝트 회고

>UI 작업을 Storyboard를 사용하지 않고, Code base로 개발을 진행하면서 코드로 UI 작업을 하는 것에 익숙해졌고, Snapkit을 통해 더 편하게 Constraints를 지정할 수 있었습니다.<br>Storyboard는 직관적인 인터페이스로 쉽게 UI를 배치할 수 있다는 장점이 있지만, Code base에 비해 무겁고, 협업시 충돌이 발생할 수 있다는 문제점이 있기 때문에 앞으로 Storyboard 보다는 Code base 개발에 익숙해지도록 노력할 것 입니다.

<br>

> CompositionalLayout을 사용해서 1개의 CollectionView에 여러 Section으로 나누고, Section마다 서로 다른 레이아웃을 구성할 수 있다는 것을 알았고, 이를 통해 좀 더 효율적인 코드 구성이 가능하다는 것을 배웠습니다.

<br>

>MVVM-C 패턴을 적용하면서 가장 큰 감명을 받았던 것은 기능 추가 또는 테스트 코드를 작성 하는데 굉장히 편리하다는 것입니다.<br>Protocol을 사용해서 객체간 의존성을 낮추고, Coordinator 패턴을 사용해서 화면 전환 로직을 위임했기 때문에 DI도 쉽게 할 수 있었습니다.<br>그렇기 때문에 규모가 큰 프로젝트의 경우 MVVM 패턴이 유용할 것이라고 생각합니다.

<br>

>RxSwift를 사용하면서 Observable과 Observer의 동작 방식에 대해 명확하게 알게되었고, URLSession, CoreData와 함께 사용하면서 기존에 사용하던 CompletionHandler의 callback 방식에 비해 훨씬 간단하고, 가독성이 높다는 것을 느꼈습니다. <br>
또한, UI요소에 Observable이 방출하는 데이터를 바인딩하면서 기존에 사용했던 Delegate, Property Observer, NotificationCenter 에 비해 구현이 간단해졌습니다.
