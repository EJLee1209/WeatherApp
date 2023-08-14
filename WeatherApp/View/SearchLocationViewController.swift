//
//  SearchLocationViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit
import RxSwift
import RxCocoa


class SearchLocationViewController: UIViewController, ViewModelBindableType {
    
    //MARK: - Properties
    
    let bag = DisposeBag()
    
    var viewModel: SearchLocationViewModel!
    func bindViewModel() {
        // 뷰 바인딩
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: bag)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
    }
    
    
}
