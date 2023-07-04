//
//  LZSettingToggleTableViewCell.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/7/4.
//

import Foundation
import UIKit

class LZSettingToggleTableViewCell: UITableViewCell {
    lazy var titleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()

    lazy var navigationBar: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "BackgroundGray")
        contentView.addSubview(titleView)
        contentView.addSubview(toggle)
        contentView.addSubview(navigationBar)
        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(188)
        }
        toggle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().offset(-35)
            make.right.equalToSuperview().offset(-24)
            make.width.equalTo(48)
        }
        navigationBar.image = UIImage(systemName: "chevron.forward")
        navigationBar.tintColor = UIColor(named: "ContentBackground")
        titleView.font = UIFont.systemFont(ofSize: 20)
        toggle.contentMode = .center
        toggle.addTarget(self, action: #selector(switchToggle(_:)), for: .valueChanged)
    }

    func setupEvent(title: String, toggle: Bool) {
        titleView.text = title
        self.toggle.isOn = toggle
    }
    
    @objc func switchToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: LZUDKeys.SongCache.rawValue)
    }
}
 
