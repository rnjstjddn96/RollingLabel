//
//  ViewController.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import UIKit

final class ViewController: UIViewController {
    private let label: RollingLabel = .init(
        font: .boldSystemFont(ofSize: 22),
        color: .label,
        style: .autoResize
    )
    private let textField: UITextField = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
        label.setText("0원")
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
        textField.placeholder = "set price"
        textField.borderStyle = .bezel
        textField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.label.setText(text)
        }
        
        return true
    }
}


