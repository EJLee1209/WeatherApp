//
//  SectionHeaderView.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "5일간의 일기예보"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    static let identifier = "SectionHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(30)
        }
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

