//
//  ForecastDailyCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit

class ForecastDailyCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
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
        let sv = UIStackView(arrangedSubviews: [weatherImageView, tempLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fill
        return sv
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Properties
    
    private func makeUI() {
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalTo(dayLabel.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
    }
    
    func configure(data: WeatherDataType, dateFormatter: DateFormatter, tempFormatter: NumberFormatter) {
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(for: data.date)
        
        weatherImageView.image = UIImage.from(name: data.icon)
        
        let tempStr = tempFormatter.string(for: data.temperature) ?? "-"
        tempLabel.text = "\(tempStr)°"
    }
}
