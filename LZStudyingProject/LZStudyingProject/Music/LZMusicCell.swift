//
//  LZMusicCell.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation
import UIKit


class LZMusicCell: UITableViewCell {
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-12)
            make.width.equalTo(iconView.snp.height)
            make.left.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.top.equalTo(iconView.snp.top)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    
    func setupEvent(music: Music) {
        iconView.image = UIImage(named: music.animeInfo.logo)
        titleLabel.text = music.animeInfo.title
        subTitleLabel.text = music.author.unicodeScalars.map({ $0.value }).reduce("") { $0 + String( $1 ) }
//        subTitleLabel.text = music.author.removingPercentEncoding
    }
}
