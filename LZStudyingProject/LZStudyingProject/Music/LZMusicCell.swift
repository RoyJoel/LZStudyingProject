//
//  LZMusicCell.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation
import UIKit
import SDWebImage


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
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(iconView.snp.top)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        iconView.setCorner(radii: 10)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.tintColor = UIColor(named: "ContentBackground")
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.tintColor = UIColor(named: "SubTitleTintColor")
    }
    
    
    func setupEvent(music: Music) {
        iconView.sd_setImage(with: URL(string: music.animeInfo.logo))
        titleLabel.text = music.animeInfo.title
        subTitleLabel.text = music.author
    }
}
