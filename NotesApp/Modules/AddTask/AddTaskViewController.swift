//
//  AddTaskViewController.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import UIKit

// MARK: - AddTaskViewControllerProtocol
protocol AddTaskProtocol: UIViewController {}

class AddTaskViewController: CustomVC {
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = Names.titleLabelText
        return label
    }()
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.purple.cgColor
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .gray()
        button.configuration?.title = Names.addTaskButtonText
        button.configuration?.baseForegroundColor = .systemPurple
        button.configuration?.image = UIImage(systemName: Images.addTaskButton)
        button.configuration?.imagePadding = 10
        button.configuration?.imageColorTransformer = .monochromeTint
        return button
    }()
    
    private lazy var changeToBlackButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Images.squareFill)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var changeToGreenButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Images.squareFill)?.withTintColor(.green, renderingMode: .alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var changeToRedButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Images.squareFill)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var changeToOrangeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Images.squareFill)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var changeToCyanButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Images.squareFill)?.withTintColor(.cyan, renderingMode: .alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var changeToBoldButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Names.bold)?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(changeTextAttributes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // MARK: - Variables
    var presenter: AddTaskPresenterProtocol?
    private var textColor = Names.black
    private var isBold = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaps()
        setupNavBarWithoutTitle()
        navigationItem.hidesBackButton = true
        setupViewController()
    }
    
    // MARK: - @objc methods
    @objc
    private func addTaskButtonTapped() {
        guard let title = titleTextView.text else {
            return
        }
        
        let color = textColor
        
        let model = TaskModel(title: title,
                              color: color,
                              isBold: isBold
        )
        presenter?.addTask(with: model)
    }
    
    @objc
    private func changeTextAttributes(_ sender: UIButton) {
        switch sender {
        case changeToBlackButton:
            titleTextView.textColor = .black
            textColor = Names.black
        case changeToGreenButton:
            titleTextView.textColor = .green
            textColor = Names.green
        case changeToRedButton:
            titleTextView.textColor = .red
            textColor = Names.red
        case changeToOrangeButton:
            titleTextView.textColor = .orange
            textColor = Names.orange
        case changeToCyanButton:
            titleTextView.textColor = .cyan
            textColor = Names.cyan
        case changeToBoldButton:
            changeBold()
        default:
            break
        }
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - MainViewControllerProtocol impl
extension AddTaskViewController: AddTaskProtocol {}

// MARK: - private methods
private extension AddTaskViewController {
    private func addTaps() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    func changeBold() {
        isBold = !isBold
        if isBold {
            titleTextView.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            titleTextView.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        buttonsStackView.addArrangedSubview(changeToBlackButton)
        buttonsStackView.addArrangedSubview(changeToGreenButton)
        buttonsStackView.addArrangedSubview(changeToRedButton)
        buttonsStackView.addArrangedSubview(changeToOrangeButton)
        buttonsStackView.addArrangedSubview(changeToCyanButton)
        buttonsStackView.addArrangedSubview(changeToBoldButton)
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextView)
        view.addSubview(buttonsStackView)
        view.addSubview(addTaskButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            titleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleTextView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonsStackView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -20),
            
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -350),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.widthAnchor.constraint(equalToConstant: 180),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
