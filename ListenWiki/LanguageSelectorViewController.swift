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
    }
}


extension LanguageSelectorViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
