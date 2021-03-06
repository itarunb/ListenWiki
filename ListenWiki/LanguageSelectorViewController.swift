//
//  LanguageSelectorViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 27/09/20.
//  Copyright © 2020 FlawlessApps. All rights reserved.
//

import UIKit
import Mixpanel

class LanguageSelectorViewController: UIViewController {

    private let pickerDataSource : LanguagePickerViewDataSource
    private var pickerView : UIPickerView?
    
    private var topLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You will be listening to Wikipedia page audio in the language of your choice."
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    private let bgImageview : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "languageChooseBackground")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        Mixpanel.mainInstance().track(event: AnalyticsContants.Mixpanel.EventName.languageScreenShown)
    }
    
    private func addComponentsViews() {
        view.addSubview(bgImageview)
        NSLayoutConstraint.activate([
            bgImageview.leftAnchor.constraint(equalTo: view.leftAnchor),
            bgImageview.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            bgImageview.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            bgImageview.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
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
        
        view.addSubview(topLabel)
        NSLayoutConstraint.activate([
            topLabel.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: -20),
            topLabel.centerXAnchor.constraint(equalTo: picker.centerXAnchor),
            topLabel.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 30),
            topLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -30),
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
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold),
                          NSAttributedString.Key.foregroundColor : UIColor.white]
        return NSAttributedString(string: language.displayStr, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
