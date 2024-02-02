//
//  ShowTaskDescriptionViewController.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 30.01.2024.
//

import UIKit

// MARK: - ShowTaskDescriptionProtocol
protocol ShowTaskDescriptionProtocol: UIViewController {
    func showView(_ model: TaskViewModel)
}

class ShowTaskDescriptionViewController: CustomVC {
    // MARK: - UI
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.title = Names.edit
        button.configuration?.baseForegroundColor = .systemPurple
        button.configuration?.image = UIImage(systemName: Images.pencil)
        button.configuration?.imagePadding = 10
        button.configuration?.imageColorTransformer = .monochromeTint
        
        return button
    }()
    
    private lazy var deleteTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(deleteTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .gray()
        button.configuration?.title = Names.delete
        button.configuration?.baseForegroundColor = .systemPurple
        button.configuration?.image = UIImage(systemName: Images.minus)
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
    var presenter: ShowTaskDescriptionPresenterProtocol?
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
    private func editTaskButtonTapped() {
        guard let title = titleTextView.text else { return }
        let color = textColor
        let model = TaskModel(title: title, color: color, isBold: isBold)
        presenter?.editTask(with: model)
    }
    
    @objc
    private func deleteTaskButtonTapped() {
        presenter?.deleteTask()
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

// MARK: - ShowTaskDescriptionViewController impl
extension ShowTaskDescriptionViewController: ShowTaskDescriptionProtocol {
    func showView(_ model: TaskViewModel) {
        titleTextView.text = model.title
        timeLabel.text = model.datetime
        textColor = model.color
        
        titleTextView.textColor = UIColor.returnColor(from: model.color)
        
        if model.isBold {
            titleTextView.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
}

// MARK: - private methods
private extension ShowTaskDescriptionViewController {
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
        presenter?.viewDidLoad()
    }
    
    func addSubviews() {
        buttonsStackView.addArrangedSubview(changeToBlackButton)
        buttonsStackView.addArrangedSubview(changeToGreenButton)
        buttonsStackView.addArrangedSubview(changeToRedButton)
        buttonsStackView.addArrangedSubview(changeToOrangeButton)
        buttonsStackView.addArrangedSubview(changeToCyanButton)
        buttonsStackView.addArrangedSubview(changeToBoldButton)
        
        view.addSubview(titleTextView)
        view.addSubview(timeLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(editTaskButton)
        view.addSubview(deleteTaskButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleTextView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -20),
            
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor ,constant: -10),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonsStackView.bottomAnchor.constraint(equalTo: editTaskButton.topAnchor, constant: -20),
            
            editTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -350),
            editTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            editTaskButton.widthAnchor.constraint(equalToConstant: 120),
            editTaskButton.heightAnchor.constraint(equalToConstant: 60),
            
            deleteTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -350),
            deleteTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            deleteTaskButton.widthAnchor.constraint(equalToConstant: 120),
            deleteTaskButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
