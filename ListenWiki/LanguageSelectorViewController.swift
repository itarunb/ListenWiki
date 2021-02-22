//
//  LanguageSelectorViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 27/09/20.
//  Copyright © 2020 FlawlessApps. All rights reserved.
//

import UIKit

class LanguageSelectorViewController: UIViewController {

    private let pickerDataSource : LanguagePickerViewDataSource
    private var pickerView : UIPickerView?
    
    private let doneButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attrStr = NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue , NSAttributedString.Key.font : UIFont.systemFont(ofSize:20, weight: .medium)])
        button.setAttributedTitle(attrStr, for: .normal)
        return button
    }()
    
    var selectionDone : ((Language?) -> Void)?
    
    init(pickerDataSource : LanguagePickerViewDataSource) {
        self.pickerDataSource = pickerDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
        addComponentsViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Language"
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        pickerView?.selectRow(pickerDataSource.getSelectedLanguageIndex(), inComponent: 0, animated: true)
    }
    
    private func addComponentsViews() {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = pickerDataSource
        picker.delegate =  self
        picker.showsSelectionIndicator = true
        view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.pickerView = picker
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            doneButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -10)
        ])
    }
    
    @objc private func doneTapped() {
        selectionDone?(pickerDataSource.getSelectedLanguage())
    }
}


extension LanguageSelectorViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDataSource.languageSelectedAtIndex(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let language = pickerDataSource.getLanguageAtRow(row) else {
            return NSAttributedString()
        }
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor : UIColor.blue]
        return NSAttributedString(string: language.displayStr, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.bounds.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
