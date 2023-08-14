//
//  SectionBackgroundView.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    
    static let background = "background-element-kind"
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7949617505, green: 0.7949617505, blue: 0.8408269716, alpha: 0.6455142798)
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        backgroundView.layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
