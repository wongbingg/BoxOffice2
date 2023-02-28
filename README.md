###### tags: `README`

# BoxOffice2

## 프로젝트 소개
박스오피스를 일별, 주중/주말 순위 로 구분해서 볼 수 있는 앱 입니다.


## 📑 목차

- [🔑 핵심기술](#🔑-핵심기술)
- [📱 실행화면](#📱-실행화면)
- [🔭 프로젝트 구조](#🔭-프로젝트-구조)
- [⚙️ 적용한 기술](#⚙️-적용한-기술)
- [⚠️ 트러블 슈팅](#⚠️-트러블-슈팅)
    
## 🔑 핵심기술
- **`MVVM + C`**
    - MVVM 패턴, Coordinator
- **`UI 구현`**
    - 코드 베이스 UI
    - 오토레이아웃
    - CollectionView Compositional Layout
    - Custom Modal
- **`비동기처리`**
    - RxSwift
- **`이미지 캐싱`**
    - URLCache
    - Dictionary Cache
<br>
    
## 📱 실행화면
    
### 홈화면
|일별 박스오피스 화면|주간/주말 박스오피스 화면|
|:---:|:---:|
|<img src="https://i.imgur.com/DJW58W9.gif" width="200">|<img src="https://i.imgur.com/WQF7ugU.gif" width="200">|

<br>
    
## 🔭 프로젝트 구조

### [Presentation Layer]
#### - <U>HomeScene</U>
- FlowCoordinator
    - HomeFlowCoordinator
- HomeView
    - ViewModel
    - View
- MovieDetailView
    - ViewModel
    - View

### [Domain Layer]
#### - <U>Entity</U>
- MovieCellData
- MovieDetailData
#### - <U>UseCase</U>
- SearchDailyBoxOfficeUseCase
- SearchWeekDaysBoxOfficeUseCase
- SearchWeekEndBoxOfficeUseCase
- SearchMovieDetailBoxOfficeUseCase


### [Data Layer]
#### - <U>Network</U>
- DailyBoxOfficeListResponseDTO
- WeeklyBoxOfficeListResponseDTO
- MovieDetailInfoResponseDTO
- MoviePosterResponseDTO
#### - <U>Repository</U>
- MovieRepository
- PosterImageRepository



<br>
    
## ⚙️ 적용한 기술

### ✅ CollectionView Compositional Layout

보기모드에 따라 Layout을 다르게 적용 해주었습니다. 

<details>
    <summary>일별 박스오피스 레이아웃 생성 메서드</summary>
    
```swift
func createDailyLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: 10,
        bottom: 0,
        trailing: 10
    )

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.25)
    )
    let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize,
        subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)

    let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(60)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: "headerView",
        alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]

    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}
```
    
</details>
    

<details>
    <summary>주중/ 주말 박스오피스 레이아웃 생성 메서드</summary>
    
```swift
func createWeeklyLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: 10,
        bottom: 0,
        trailing: 10
    )

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.45),
        heightDimension: .fractionalHeight(0.45)
    )
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(50)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: "headerView",
        alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]

    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}
```
    
</details>


### ✅ Custom Modal View
- `보기모드 변경 버튼(상단 버튼)`, `캘린더 버튼`, `출연진 더보기 버튼` 을 Custom Modal 형식으로 구현 했습니다.  
- Presentation Controller 에서 화면 전환 시 dimmingView 처리와 UIGesture를 통해 화면 dismiss를 구현 했습니다.

|보기모드 변경|날짜 선택|출연진 보기|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/XhJ90We.gif" width="150">|<img src="https://i.imgur.com/v9DKEme.gif" width="150">|<img src="https://i.imgur.com/ZbzdpJn.gif" width="150">|


### ✅ 지역화

- 일본, 미국 에서 사용할 수 있도록 Localization을 적용 했습니다. 

|일본 지역화|미국 지역화|
|:---:|:---:|
|<img src="https://i.imgur.com/6hnzepQ.jpg" width="150">|<img src="https://i.imgur.com/1mg8OFT.jpg" width="150">|


### ✅ 다크모드 대응

- 라이트 모드와 다크 모드에서 색감 차이가 없도록 `Semantic Color`를 사용했습니다. 

|일별 박스오피스 화면|보기모드 변경 모달뷰|주간/주말 박스오피스 화면|캘린더뷰|
|:---:|:---:|:---:|:---:|
|<img src="https://i.imgur.com/ERmKeEa.jpg" width="150">|<img src="https://i.imgur.com/lXdvWbu.jpg" width="150">|<img src="https://i.imgur.com/z7fSx4l.jpg" width="150">|<img src="https://i.imgur.com/n9rgY2F.jpg" width="150">|

   
### ✅ 가로모드, 세로모드 대응

- 가로모드와 세로모드에 대응할 수 있도록 Layout을 설정 해주었습니다.
- 기기 회전 이벤트에 Notification을 적용하여 layout을 변경해주었습니다.

|일별 박스오피스 화면|주간/주말 박스오피스 화면|
|:---:|:---:|
|<img src="https://i.imgur.com/nD4Nbu9.gif" width="350">|<img src="https://i.imgur.com/HVVimST.gif" width="350">|


### ✅ 접근성 향상

- 시력이 좋지 않은 사용자를 위해 Dynamic Type을 적용 했습니다. 
- 시각 장애인 사용자를 위해 Voice Over를 적용 했습니다.

|일별 박스오피스 화면|주간/주말 박스오피스 화면|
|:---:|:---:|
|<img src="https://i.imgur.com/406ZobP.gif" width="150">|<img src="https://i.imgur.com/GIrP7Ni.gif" width="150">|


### ✅ Unit Test

- 네트워킹에 대한 Unit Test
- UseCase에 대한 Unit Test
- ViewModel에 대한 Unit Test
 
## ⚠️ 트러블 슈팅

### 🛠 Struct타입 모델을 Diffable DataSource에 사용하기

```swift
DiffableDataSource 에서 기존에는 item identifier로 모델타입을 넣어 주었습니다. 
하지만 참고해본 `개발자 포럼`에서 값타입의 모델을 사용 할 경우, uuid값을 item identifier
로 넣어주는 것이 데이터 관리에 용이하고, 중복으로 인한 크래쉬를 방지하기 쉽다고 하여 적용 해보았습니다.
```

```swift
func createDailyCellRegistration() -> UICollectionView.CellRegistration<ListCell, String> {
        
    let cellRegistration = UICollectionView.CellRegistration<ListCell, String> { (cell, _, id) in

        let item = self.viewModel.dailyBoxOffices.value.filter { $0.uuid == id }
        self.setupCell(with: item[0], at: cell, id: id)
    }
    return cellRegistration
}
```

```swift
HomeCollectionView의 Cell Registration 부분에서 id 값에 해당하는 모델을 찾아
setupCell 메서드에 적용 해주었습니다. 
```

### 🛠 셀 업로드 속도 향상 

- 이미지 요청의 반환속도 때문에 전체 Cell 업데이트 속도의 지연이 있었습니다. 
- 이를 해결하기 위해 이미지는 PosterImageRepository에서 따로 받아오도록 작업하고, 나머지 셀 정보들은 바로 업데이트가 되도록 수정 했습니다. 
- 셀의 Text 정보들이 미리 업로드 된 후, 이미지를 받아왔을 때 또 한번 업데이트를 해주어야 하는 것에서 문제가 생겼습니다. 
- 셀을 업데이트 해주는 방법에는 snapshot의 reloadItem() 과 reconfigureItems() 메서드가 있습니다.


### 🛠 reloadItem과 reconfigureItems의 차이점

NSDiffableDataSourceSnapshot 에 존재하는 reloadItem() 메서드와 reconfigureItems()
메서드의 차이점에 대해 알아봤습니다. 

- reloadItem() 메서드
    - 다른 셀 타입으로 업데이트 해야할 때 사용합니다.

- reconfigureItems() 메서드
    - 같은 셀 타입에, 정보만 업데이트 할 때 사용합니다. 

`Make blazing fast lists and collection views WWDC`를 참고해본 결과, reconfigureItem() 메서드의 효율성이 더 좋다고 판단하여 이를 적용 해주었습니다.

|로딩 속도 개선 전|로딩 속도 개선 후|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/95671495/211021219-698d76f8-bf8f-4d1f-a9fe-2ac5ec3aa919.gif" width="200">|<img src="https://i.imgur.com/9tSRVOC.gif" width="200">|
|`로딩속도 약 3초`|`로딩 속도 1초 이내`|



## 🔗 References
- [Table and Collection View Cells Reload Improvements in iOS 15](https://swiftsenpai.com/development/cells-reload-improvements-ios-15/)
- [WWDC - Make blazing fast lists and collection views](https://developer.apple.com/videos/play/wwdc2021/10252/?time=147)
