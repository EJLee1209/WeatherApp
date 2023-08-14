//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UITabBarController, ViewModelBindableType {
    
    //MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
        cv.register(ForecastHourlyCell.self, forCellWithReuseIdentifier: ForecastHourlyCell.identifier)
        cv.register(ForecastDailyCell.self, forCellWithReuseIdentifier: ForecastDailyCell.identifier)
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
            make.edges.equalToSuperview()
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
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
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
                section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
                
                // 섹션 배경 생성
//                let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.background)
//                section.decorationItems = [sectionBackground]
                
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(self.view.bounds.width), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(self.view.bounds.width), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
                
                // 섹션에 헤더 추가
//                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)) // Header height is estimated
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerSize,
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .topLeading
//                )
//
//                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                fatalError()
            }
        }
        
//        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.background)
        return layout
    }
}


extension Reactive where Base: UIImageView {
    
    var background: Binder<String> {
        return Binder(self.base) { iv, imageName in
            iv.image = UIImage(named: imageName)
        }
    }
    
}

