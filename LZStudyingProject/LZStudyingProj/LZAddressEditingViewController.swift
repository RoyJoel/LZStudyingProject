//
//  LZAddressEditingViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/25.
//

import Foundation
import TMComponent
import UIKit

class LZAddressEditingViewController: UIViewController, UITextFieldDelegate {
    var isDefault: Bool = false

    var address = Address()
    let provinceDs = provinceDataSource()
    let cityDs = cityDataSource()
    let districtDs = districtDataSource()
    let sexDs = sexDataSource()
    var saveCompletionHandler: ((Address) -> Void)?
    var addCompletionHandler: ((Address) -> Void)?

    lazy var sexSelectedView: TMPopUpView = {
        let view = TMPopUpView(frame: .zero, style: .plain)
        return view
    }()

    lazy var provinceSelectionView: TMPopUpView = {
        let view = TMPopUpView(frame: .zero, style: .plain)
        return view
    }()

    lazy var citySelectionView: TMPopUpView = {
        let view = TMPopUpView(frame: .zero, style: .plain)
        return view
    }()

    lazy var districtSelectionView: TMPopUpView = {
        let view = TMPopUpView(frame: .zero, style: .plain)
        return view
    }()

    lazy var nameTextField: TMTextField = {
        let TextField = TMTextField()
        return TextField
    }()

    lazy var phoneNumberTextField: TMTextField = {
        let TextField = TMTextField()
        return TextField
    }()

    lazy var detailedAddressTextField: TMTextField = {
        let TextField = TMTextField()
        return TextField
    }()

    lazy var defaultSelectionView: TMServerView = {
        let serveView = TMServerView()
        return serveView
    }()

    lazy var doneBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(nameTextField)
        view.addSubview(sexSelectedView)
        view.addSubview(phoneNumberTextField)
        view.addSubview(provinceSelectionView)
        view.addSubview(citySelectionView)
        view.addSubview(districtSelectionView)
        view.addSubview(detailedAddressTextField)
        view.addSubview(doneBtn)
        view.addSubview(defaultSelectionView)

        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(188)
            make.height.equalTo(44)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }

        sexSelectedView.frame = CGRect(x: 48 + UIScreen.main.bounds.width * 0.6, y: 188, width: 88, height: 44)
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(24)
        }

        provinceSelectionView.frame = CGRect(x: 24, y: 300, width: 102, height: 44)
        citySelectionView.frame = CGRect(x: 150, y: 300, width: 102, height: 44)
        districtSelectionView.frame = CGRect(x: 276, y: 300, width: 102, height: 44)

        detailedAddressTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(68)
            make.height.equalTo(44)
        }

        defaultSelectionView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(detailedAddressTextField.snp.bottom).offset(12)
            make.width.equalTo(108)
            make.height.equalTo(108)
        }

        doneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(defaultSelectionView.snp.bottom).offset(68)
            make.width.equalTo(88)
            make.height.equalTo(44)
        }
        doneBtn.setTitle("保存", for: .normal)
        doneBtn.addTarget(self, action: #selector(saveAddress), for: .touchDown)
        doneBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        doneBtn.setCorner(radii: 10)
        doneBtn.backgroundColor = UIColor(named: "TennisBlur")
        nameTextField.textField.textAlignment = .center
        phoneNumberTextField.textField.textAlignment = .center

        nameTextField.textField.placeholder = "Enter your name"
        phoneNumberTextField.textField.placeholder = "enter your phone number"
        detailedAddressTextField.textField.placeholder = "detail address"

        sexSelectedView.dataSource = sexDs
        sexSelectedView.setupSize()
        view.bringSubviewToFront(sexSelectedView)
        sexSelectedView.delegate = sexSelectedView
        sexSelectedView.selectedCompletionHandler = { index in
            let selectedSex = self.sexDs.sexConfig.remove(at: index)
            self.sexDs.sexConfig.insert(selectedSex, at: 0)
            self.sexSelectedView.reloadData()
        }

        LZGDAddressRequest.requestGDAddress { res in
            guard let res = res else {
                return
            }
            self.provinceDs.provinces = res
            self.provinceSelectionView.dataSource = self.provinceDs
            self.provinceSelectionView.setupSize()
            self.view.bringSubviewToFront(self.provinceSelectionView)
            self.provinceSelectionView.delegate = self.provinceSelectionView
            self.provinceSelectionView.reloadData()

            self.cityDs.cities = self.provinceDs.provinces[0].districts ?? []
            self.citySelectionView.dataSource = self.cityDs
            self.citySelectionView.setupSize()
            self.view.bringSubviewToFront(self.citySelectionView)
            self.citySelectionView.delegate = self.citySelectionView
            self.citySelectionView.reloadData()

            self.districtDs.districts = self.cityDs.cities[0].districts ?? []
            self.districtSelectionView.dataSource = self.districtDs
            self.districtSelectionView.setupSize()
            self.view.bringSubviewToFront(self.districtSelectionView)
            self.districtSelectionView.delegate = self.districtSelectionView
            self.districtSelectionView.reloadData()

            self.provinceSelectionView.selectedCompletionHandler = { index in
                let selectedProvince = self.provinceDs.provinces.remove(at: index)
                self.provinceDs.provinces.insert(selectedProvince, at: 0)
                self.provinceSelectionView.reloadData()

                self.cityDs.cities = selectedProvince.districts ?? []
                self.districtDs.districts = selectedProvince.districts?[0].districts ?? []
                self.citySelectionView.reloadData()
                self.districtSelectionView.reloadData()
            }

            self.citySelectionView.selectedCompletionHandler = { index in
                let selectedCity = self.cityDs.cities.remove(at: index)
                self.cityDs.cities.insert(selectedCity, at: 0)
                self.citySelectionView.reloadData()

                self.districtDs.districts = selectedCity.districts ?? []
                self.districtSelectionView.reloadData()
            }

            self.districtSelectionView.selectedCompletionHandler = { index in
                let selecteddistrict = self.districtDs.districts.remove(at: index)
                self.districtDs.districts.insert(selecteddistrict, at: 0)
                self.districtSelectionView.reloadData()
            }
            self.setupEvent(address: self.address)
        }

        let defaultSelectionConfig = TMServerViewConfig(selectedImage: "circle.fill", unSelectedImage: "circle", selectedTitle: "默认地址", unselectedTitle: "默认地址")
        defaultSelectionView.setupEvent(isServing: false, config: defaultSelectionConfig)
        defaultSelectionView.addTapGesture(self, #selector(changeDefault))
        defaultSelectionView.isUserInteractionEnabled = true
        nameTextField.textField.delegate = self
        phoneNumberTextField.textField.delegate = self
        detailedAddressTextField.textField.delegate = self
    }

    func setupEvent(address: Address) {
        self.address = address

        if let sex = self.sexDs.sexConfig.first(where: { $0.rawValue == address.sex.rawValue }) {
            sexDs.sexConfig.removeAll { $0.rawValue == address.sex.rawValue }
            sexDs.sexConfig.insert(sex, at: 0)
        }

        if let province = self.provinceDs.provinces.first(where: { $0.name == address.province }) {
            provinceDs.provinces.removeAll(where: { $0.name == address.province })
            provinceDs.provinces.insert(province, at: 0)

            provinceSelectionView.reloadData()
            cityDs.cities = province.districts ?? []
            districtDs.districts = province.districts?[0].districts ?? []
            citySelectionView.reloadData()
            districtSelectionView.reloadData()
        }

        if let city = self.cityDs.cities.first(where: { $0.name == address.city }) {
            cityDs.cities.removeAll(where: { $0.name == address.city })
            cityDs.cities.insert(city, at: 0)
            citySelectionView.reloadData()
            districtDs.districts = city.districts ?? []
            districtSelectionView.reloadData()
        }

        if let area = self.districtDs.districts.first(where: { $0.name == address.area }) {
            districtDs.districts.removeAll { $0.name == address.area }
            districtDs.districts.insert(area, at: 0)
            districtSelectionView.reloadData()
        }

        nameTextField.textField.text = address.name
        phoneNumberTextField.textField.text = address.phoneNumber
        detailedAddressTextField.textField.text = address.detailedAddress
        isDefault = address.isDefault
        defaultSelectionView.changeStats(to: isDefault)
    }

    func openAddingMode() {
        doneBtn.removeTapGesture(self, #selector(saveAddress))
        doneBtn.addTarget(self, action: #selector(addAddress), for: .touchDown)
    }

    func getAddressInfo() -> Address {
        address = Address(id: address.id, name: nameTextField.textField.text ?? "", sex: sexDs.sexConfig[0], phoneNumber: phoneNumberTextField.textField.text ?? "", province: provinceDs.provinces[0].name, city: cityDs.cities[0].name, area: districtDs.districts[0].name, detailedAddress: detailedAddressTextField.textField.text ?? "", isDefault: isDefault)
        return address
    }

    @objc func changeDefault() {
        isDefault.toggle()
        defaultSelectionView.changeStats(to: isDefault)
    }

    @objc func addAddress() {
        let newAddress = getAddressInfo()
        LZAddressRequest.addAddress(address: AddressRequest(address: newAddress, userId: LZUser.user.id)) { address in
            self.address = address
            (self.addCompletionHandler ?? { _ in })(address)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func saveAddress() {
        let newAddress = getAddressInfo()
        LZAddressRequest.UpdateAddress(address: AddressRequest(address: newAddress, userId: LZUser.user.id)) { address in
            self.address = address
            (self.saveCompletionHandler ?? { _ in })(address)
        }
        navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

class sexDataSource: NSObject, UITableViewDataSource {
    var sexConfig = Sex.allCases
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        sexConfig.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupEvent(title: sexConfig[indexPath.row] == .Man ? "先生" : "女士")
        return cell
    }
}

class provinceDataSource: NSObject, UITableViewDataSource {
    var provinces: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        provinces.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupEvent(title: provinces[indexPath.row].name)
        return cell
    }
}

class cityDataSource: NSObject, UITableViewDataSource {
    var cities: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        cities.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupEvent(title: cities[indexPath.row].name)
        return cell
    }
}

class districtDataSource: NSObject, UITableViewDataSource {
    var districts: [District] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        districts.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupEvent(title: districts[indexPath.row].name)
        return cell
    }
}
