//
//  ForecastHourlyCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit

class ForecastHourlyCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [timeLabel, weatherImageView, tempLabel])
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    static let identifier = "ForecastHourlyCell"
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func makeUI() {
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
    }
    
    func configure(data: WeatherDataType, dateFormatter: DateFormatter, tempFormatter: NumberFormatter) {
        dateFormatter.dateFormat = "a hh시"
        timeLabel.text = dateFormatter.string(for: data.date)
        
        weatherImageView.image = UIImage.from(name: data.icon)
        
        let tempStr = tempFormatter.string(for: data.temperature) ?? "-"
        tempLabel.text = "\(tempStr)°"
    }
    
}
