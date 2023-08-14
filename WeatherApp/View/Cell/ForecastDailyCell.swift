//
//  ForecastDailyCell.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit
import SDWebImage

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
    
    private let popLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "light_blue")
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var weatherStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weatherImageView, popLabel])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weatherStack, tempLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .equalSpacing
        return sv
    }()
    
    static let identifier = "ForecastDailyCell"
    
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
            make.left.equalTo(dayLabel.snp.right).offset(20)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: WeatherDataType, dateFormatter: DateFormatter, tempFormatter: NumberFormatter) {
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(for: data.date)
        
        let max = data.maxTemperature ?? 0.0
        let min = data.minTemperature ?? 0.0
        
        let maxTemp = tempFormatter.string(for: max) ?? "-"
        let minTemp = tempFormatter.string(for: min) ?? "-"
        
        let maxMinTemp = "최고:\(maxTemp)° 최저:\(minTemp)°"
        
        tempLabel.text = maxMinTemp
        
        if let pop = data.pop, pop > 0.0 {
            print("강수 확률 : \(pop*100)")
            popLabel.text = "\(pop * 100)%"
        }
        
        
        let urlStr = "https://openweathermap.org/img/wn/\(data.icon)@2x.png"
        guard let url = URL(string: urlStr) else { return }
        weatherImageView.sd_setImage(with: url)
        
        
    }
}
