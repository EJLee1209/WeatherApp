//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit
import SnapKit

class CurrentWeatherCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    static let identifier = "CurrentWeatherCell"
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func makeUI() {
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(from data: WeatherDataType, address: String, tempFormatter: NumberFormatter) {
        
        let attrText = NSMutableAttributedString(
            string: "\(address)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 25)]
        )
        
        let currentTemp = tempFormatter.string(for: data.temperature) ?? "-"
        
        attrText.append(NSAttributedString(
            string: "\(currentTemp)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 44)]
        ))
        
        attrText.append(NSAttributedString(
            string: "\(data.description)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 18)]
        ))
        
        let max = data.maxTemperature ?? 0.0
        let min = data.minTemperature ?? 0.0
        
        let maxTemp = tempFormatter.string(for: max) ?? "-"
        let minTemp = tempFormatter.string(for: min) ?? "-"
        
        let maxMinTemp = "최고:\(maxTemp)° 최저:\(minTemp)°"
        
        attrText.append(NSAttributedString(
            string: maxMinTemp,
            attributes: [.font: UIFont.systemFont(ofSize: 18)]
        ))
        mainLabel.attributedText = attrText
        
    }
}
