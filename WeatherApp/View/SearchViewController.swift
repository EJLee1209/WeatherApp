//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

final class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        tv.rowHeight = 50
        return tv
    }()
    
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
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func bindViewModel() {
        // ViewBinding
        
        viewModel.searchResults
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: bag)
        
        tableView.rx.modelSelected(MKLocalSearchCompletion.self)
            .flatMap { $0 }
            .bind(to: viewModel.selectedItem)
            .disposed(by: bag)
        
    }
    
    func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


