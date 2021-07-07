//
//  NewTaskViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class NewTaskViewController: UIViewController {
    var task: Task?
    var updateTask = false
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton().customButton(colorButton: UIColor(
                                                red: 21 / 255,
                                                green: 101 / 255,
                                                blue: 192 / 255,
                                                alpha: 1
                                            ),
                                            title: "Save Task",
                                            font: .boldSystemFont(ofSize: 18),
                                            colorTitle: .white,
                                            cornerRadius: 4
                                            )
        if updateTask == true {
            button.addTarget(self, action: #selector(update), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(save), for: .touchUpInside)
        }
    
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton().customButton(colorButton: UIColor(
                                                red: 240 / 255,
                                                green: 101 / 255,
                                                blue: 192 / 255,
                                                alpha: 1
                                            ),
                                            title: "Cancel Task",
                                            font: .boldSystemFont(ofSize: 18),
                                            colorTitle: .white,
                                            cornerRadius: 4
                                            )
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews([taskTextField, saveButton, cancelButton])
        if task != nil {
            taskTextField.text = task?.title
        }
        setConstraints()
        taskTextField.becomeFirstResponder()
    }

    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }

    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func save() {
        taskTextField.layer.masksToBounds = true
        taskTextField.layer.borderWidth = 1.0
        taskTextField.layer.cornerRadius = 3
        taskTextField.layer.borderColor = UIColor.red.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            taskTextField.layer.borderColor = UIColor.black.cgColor
        }
        if taskTextField.text == "" { return }
        guard let text = taskTextField.text else { return }
        DataManager.shared.saveTask(text: text)
        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func update() {
        guard let task = self.task else { return }
        if taskTextField.text == "" { return }
        guard let text = taskTextField.text else { return }
        DataManager.shared.updateTask(task: task, newTitle: text)
        dismiss(animated: true)
    }
}
