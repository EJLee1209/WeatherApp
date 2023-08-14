//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController, ViewModelBindableType {
    
    //MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7949617505, green: 0.7949617505, blue: 0.8408269716, alpha: 0.8996274834)
        return view
    }()
    
    private var locationListButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
        
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
        cv.register(ForecastHourlyCell.self, forCellWithReuseIdentifier: ForecastHourlyCell.identifier)
        cv.register(ForecastDailyCell.self, forCellWithReuseIdentifier: ForecastDailyCell.identifier)
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.contentInset.bottom = 50
        return cv
    }()
    
    var viewModel: WeatherViewModel!
    let bag = DisposeBag()
    
    func bindViewModel() {
        // ViewBinding
        
        viewModel.weatherData
            .drive(collectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: bag)
       
        viewModel.backgroundImageName
            .bind(to: backgroundImageView.rx.background)
            .disposed(by: bag)
        
        locationListButton.rx.action = viewModel.makeLocationListButtonAction()
        
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(bottomBarView)
        bottomBarView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        bottomBarView.addSubview(locationListButton)
        locationListButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(25)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(36)
        }
        
        
    }
    

}


//MARK: - CollectionView Create CompositionalLayout
extension WeatherViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(270))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(120), heightDimension: .estimated(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 30, leading: 20, bottom: 10, trailing: 20)
                
                // 섹션 배경 생성
                let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.background)
                section.decorationItems = [sectionBackground]
                
                // 섹션에 헤더 추가
//                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerSize,
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .top
//                )
//
//                section.boundarySupplementaryItems = [header]
                
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(self.collectionView.frame.width), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(self.collectionView.frame.width), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
                
                // 섹션에 헤더 추가
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30)) // Header height is estimated
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
                
                section.boundarySupplementaryItems = [header]
                
                // 섹션 배경 생성
                let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.background)
                section.decorationItems = [sectionBackground]
                
                return section
            default:
                fatalError()
            }
        }
        
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.background)
        
        return layout
    }
}



