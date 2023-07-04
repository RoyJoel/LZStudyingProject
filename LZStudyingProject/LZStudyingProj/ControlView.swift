//
//  ControlView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/25.
//

import Foundation
import TMComponent

class ControlView: TMView {
    lazy var pauseBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var lastBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var completionHandler: ((Bool) -> Void)?
    
    var isPlaying: Bool = false {
        willSet {
            if newValue == true {
                pauseBtn.setImage(UIImage(systemName: "pause")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
                (completionHandler ?? {_ in })(true)
            }else {
                pauseBtn.setImage(UIImage(systemName: "play")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
                (completionHandler ?? {_ in })(false)
            }
        }
    }
    func setupUI() {
        addSubview(pauseBtn)
        addSubview(lastBtn)
        addSubview(nextBtn)
        
        lastBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }

        pauseBtn.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        lastBtn.setImage(UIImage(systemName: "backward")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        nextBtn.setImage(UIImage(systemName: "forward")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        pauseBtn.setImage(UIImage(systemName: "play")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        pauseBtn.addTarget(self, action: #selector(pause), for: .touchDown)
    }
    
    @objc func pause() {
        isPlaying.toggle()
    }
}
