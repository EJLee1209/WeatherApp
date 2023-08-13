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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    var viewModel: WeatherViewModel!
    let bag = DisposeBag()
    
    func bindViewModel() {
        // ViewBinding
        
        
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
    }
}


