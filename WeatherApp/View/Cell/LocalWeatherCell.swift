//
//  LocalWeatherCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import UIKit
import CoreLocation
import RxSwift


class LocalWeatherCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var leftStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [addressLabel, summaryLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var rightStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tempLabel, maxMinTempLabel])
        sv.axis = .vertical
        sv.alignment = .trailing
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var containerStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [leftStack, rightStack])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()
    
    static let identifier = "LocalWeatherCell"
    
    private let bag = DisposeBag()
    
    var viewModel: LocalWeatherViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        clipsToBounds = true
        
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.address
            .bind(to: addressLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.weatherData
            .compactMap { $0 }
            .bind(to: summaryLabel.rx.description, tempLabel.rx.temperature, maxMinTempLabel.rx.minMaxTemp, backgroundImageView.rx.cellBackground)
            .disposed(by: bag)

    }
    
}




