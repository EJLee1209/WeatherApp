//
//  LocalWeatherCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import UIKit
import CoreLocation
import RxSwift


class LocalWeatherCell: UICollectionViewCell {
    
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
        sv.alignment = .leading
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        clipsToBounds = true
        layer.cornerRadius = 18
        
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
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

extension Reactive where Base: UIImageView {
    
    var cellBackground: Binder<WeatherDataType> {
        return Binder(self.base) { iv, data in
            iv.image = UIImage(named: data.backgroundImageName)
        }
    }
    
}

extension Reactive where Base: UILabel {
    
    var description: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            label.text = data.description
        }
    }
    
    var temperature: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            label.text = "\(data.temperature)°"
        }
    }
    
    var minMaxTemp: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            let max = data.maxTemperature ?? 0.0
            let min = data.minTemperature ?? 0.0
    
            let maxTemp = WeatherViewModel.tempFormatter.string(for: max) ?? "-"
            let minTemp = WeatherViewModel.tempFormatter.string(for: min) ?? "-"
            
            let maxMinTemp = "최고:\(maxTemp)° 최저:\(minTemp)°"
            
            label.text = maxMinTemp
        }
    }
    
}
