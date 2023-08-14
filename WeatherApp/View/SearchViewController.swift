//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    let viewModel: SearchViewModel
    private let bag = DisposeBag()
    
    //MARK: - LifeCycle
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func bindViewModel() {
        // ViewBinding
        
        viewModel.keyword
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: bag)
        
    }
    
}


