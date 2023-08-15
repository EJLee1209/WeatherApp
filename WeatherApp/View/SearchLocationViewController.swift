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
    private lazy var searchController = UISearchController(searchResultsController: SearchViewController(viewModel: viewModel))
    
    private let bag = DisposeBag()
    
    var viewModel: SearchViewModel!
    
    func bindViewModel() {
        // 뷰 바인딩
        
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: bag)
        
        searchController.searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.keyword)
            .disposed(by: bag)
        
        
        setupSearchBar() // viewModel이 초기화된 이후에 setupSearchBar 호출
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
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
    }
    
}
