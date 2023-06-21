//
//  LZSignUpViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/2.
//

import Foundation
import TMComponent
import UIKit

class LZSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let configItems = ["Please enter a name for yourself", "Please choose a profile picture.", "What is your gender?", "What is your age?", "Please enter a account for yourself.", "Please enter a password for yourself."]
    var currentIndex = 0

    var completionHandler: (String) -> Void = { _ in }
    var iconCompletionHandler: (Data) -> Void = { _ in }

    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        return view
    }()

    lazy var signInTitleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var nameTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()

    lazy var sexTextField: TMSelectionView = {
        let label = TMSelectionView()
        return label
    }()

    lazy var ageTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var accountTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var passwordTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var nextConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var lastConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(done)), animated: true)
        view.addSubview(progressView)
        view.addSubview(signInTitleView)
        view.addSubview(nameTextField)
        view.addSubview(iconImageView)
        view.addSubview(sexTextField)
        view.addSubview(ageTextField)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextConfigBtn)
        view.addSubview(lastConfigBtn)

        signInTitleView.isHidden = false
        nameTextField.isHidden = false
        iconImageView.isHidden = true
        sexTextField.isHidden = true
        ageTextField.isHidden = true
        accountTextField.isHidden = true
        passwordTextField.isHidden = true

        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.width.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        signInTitleView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(88)
            make.left.equalToSuperview().offset(48)
            make.width.equalTo(388)
            make.height.equalTo(50)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(288)
        }
        sexTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(88)
        }
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        nextConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        lastConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(-68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        nameTextField.tag = 200
        iconImageView.tag = 201
        sexTextField.tag = 202
        ageTextField.tag = 203
        accountTextField.tag = 204
        passwordTextField.tag = 205

        progressView.setCorner(radii: 8)
        progressView.progress = 0
        progressView.progressTintColor = UIColor(named: "BackgroundGray") // 已有进度颜色
        progressView.trackTintColor = .gray
        signInTitleView.text = configItems[currentIndex]
        nameTextField.textField.placeholder = configItems[0]
        iconImageView.image = UIImage(systemName: "camera")
        iconImageView.tintColor = UIColor(named: "ContentBackground")
        iconImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        iconImageView.addTapGesture(self, #selector(changeIcon))
        sexTextField.setupEvent(config: TMServerViewConfig(selectedImage: "circle.fill", unSelectedImage: "circle", selectedTitle: "man", unselectedTitle: "woman"))
        ageTextField.textField.placeholder = configItems[3]
        accountTextField.textField.placeholder = configItems[4]
        passwordTextField.textField.placeholder = configItems[5]
        let nextBtnConfig = TMButtonConfig(title: "Next Step", action: #selector(stepForward), actionTarget: self)
        nextConfigBtn.setupEvent(config: nextBtnConfig)
        let lastBtnConfig = TMButtonConfig(title: "Back", action: #selector(stepBackward), actionTarget: self)
        lastConfigBtn.setupEvent(config: lastBtnConfig)
    }

    func showSubView(tag: Int) {
        currentIndex = tag - 200
        progressView.isHidden = true
        nextConfigBtn.isHidden = true
        lastConfigBtn.isHidden = true
        signInTitleView.text = configItems[currentIndex]
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.isHidden = false
            // 遍历所有的子视图，并隐藏除了标记为 201 之外的所有视图
            for subview in view.subviews where subview != viewWithTag {
                subview.isHidden = true
            }
            signInTitleView.isHidden = false
        }
    }

    func setUserInfo(name: String, icon: Data, sex: Sex, age: Int) {
        accountTextField.textField.text = LZUser.user.loginName
        passwordTextField.textField.text = LZUser.user.password
        nameTextField.textField.text = name
        iconImageView.image = UIImage(data: icon)
        sexTextField.isLeft = sex == .Man ? true : false
        ageTextField.textField.text = "\(age)"
    }

    func getUserInfo() {
        LZUser.user.loginName = accountTextField.textField.text ?? ""
        LZUser.user.password = passwordTextField.textField.text ?? ""
        LZUser.user.name = nameTextField.textField.text ?? ""
        LZUser.user.icon = (iconImageView.image?.pngData() ?? Data()).base64EncodedString()
        LZUser.user.sex = sexTextField.isLeft ? .Man : .Woman
        LZUser.user.age = Int(ageTextField.textField.text ?? "0") ?? 0
        LZUser.user.points = 0
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func stepForward() {
        if currentIndex < configItems.count - 1 {
            currentIndex += 1
            if let view = view.viewWithTag(currentIndex + 199), view is TMTextField {
                if let text = (view as? TMTextField)?.textField.text, !text.isEmpty {
                    if currentIndex == 10 {
                        nextConfigBtn.isEnabled = false
                        LZPlayerRequest.searchPlayer(loginName: text, completionHandler: { res in
                            if res {
                                self.currentIndex -= 1
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("Account already exists", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                                }
                                self.nextConfigBtn.isEnabled = true
                            } else {
                                self.progressView.setProgress(Float(self.currentIndex) / Float(self.configItems.count), animated: true)
                                self.signInTitleView.text = self.configItems[self.currentIndex]
                                self.view.viewWithTag(self.currentIndex + 199)?.isHidden = true
                                self.view.viewWithTag(self.currentIndex + 200)?.isHidden = false
                                if let thisView = view.viewWithTag(self.currentIndex + 200) as? TMPopUpView {
                                    self.view.bringSubviewToFront(thisView)
                                }
                                self.nextConfigBtn.isEnabled = true
                            }
                        })
                    } else {
                        progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                        signInTitleView.text = configItems[currentIndex]
                        self.view.viewWithTag(currentIndex + 199)?.isHidden = true
                        self.view.viewWithTag(currentIndex + 200)?.isHidden = false
                        if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                            self.view.bringSubviewToFront(thisView)
                        }
                    }
                } else {
                    currentIndex -= 1
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("No Content Input", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                    }
                }
            } else {
                progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                signInTitleView.text = configItems[currentIndex]
                view.viewWithTag(currentIndex + 199)?.isHidden = true
                view.viewWithTag(currentIndex + 200)?.isHidden = false
                if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                    view.bringSubviewToFront(thisView)
                }
            }
        } else if currentIndex == configItems.count - 1 {
            getUserInfo()
            LZUser.signUp { token, error in
                guard error == nil else {
                    if self.view.window != nil {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("login failed", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        self.view.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    return
                }
                var loggedinUser = (UserDefaults.standard.array(forKey: LZUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                loggedinUser.append(LZUser.user.loginName)
                UserDefaults.standard.set(loggedinUser, forKey: LZUDKeys.loggedinUser.rawValue)
                UserDefaults.standard.set(token, forKey: LZUDKeys.JSONWebToken.rawValue)
                // 登录成功后，跳转到下一个界面
                if let window = self.view.window {
                    let homeVC = TabViewController()
                    window.rootViewController = homeVC
                }
            }
        }
    }

    @objc func stepBackward() {
        if currentIndex > 0 {
            currentIndex -= 1
            progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
            signInTitleView.text = configItems[currentIndex]
            view.viewWithTag(currentIndex + 200)?.isHidden = false
            view.viewWithTag(currentIndex + 201)?.isHidden = true
            if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                view.bringSubviewToFront(thisView)
            }
        } else if currentIndex == 0 {
            dismiss(animated: true)
        }
    }

    @objc func done() {
        let tag = currentIndex + 200
        if let selectedString = (view.viewWithTag(tag) as? TMTextField)?.textField.text {
            completionHandler(selectedString)
        } else if let selectedString = (view.viewWithTag(tag) as? TMSelectionView)?.isLeft {
            completionHandler(selectedString == true ? Sex.Man.rawValue : Sex.Woman.rawValue)
        } else if let selectedIcon = (view.viewWithTag(tag) as? UIImageView)?.image?.pngData() {
            iconCompletionHandler(selectedIcon)
        } else {
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func changeIcon() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}
