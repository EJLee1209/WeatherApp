//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit

class WeatherViewController: UITabBarController, ViewModelBindableType {
    
    //MARK: - Properties
    var viewModel: WeatherViewModel!
    
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
        
    }
}


