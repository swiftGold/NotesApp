//
//  MainCollectionViewCell.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import UIKit

// MARK: - MainCollectionViewCell
protocol MainCollectionViewCellDelegate: AnyObject {
    func editButtonDidTap(with model: TaskViewModel)
    func deleteButtonDidTap(with model: TaskViewModel)
}

// MARK: - MainCollectionViewCell
final class MainCollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    private let bgImageView: UIImageView = {
        let image = UIImage(named: Images.note)
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pencil.circle")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var deleteTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "minus.circle")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(deleteTaskButtonTapped), for: .touchUpInside)
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
    weak var delegate: MainCollectionViewCellDelegate?
    var textColor = ""
    var isBold = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(with model: TaskViewModel) {
        textColor = model.color
        isBold = model.isBold
        
        titleLabel.text = model.title
        timeLabel.text = "\(model.datetime)"
        titleLabel.textColor = UIColor.returnColor(from: model.color)
        
        if model.isBold {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    // MARK: - @Objc Methods
    @objc
    private func editTaskButtonTapped() {
        let model = getTaskViewModel()
        delegate?.editButtonDidTap(with: model)
    }
    
    @objc
    private func deleteTaskButtonTapped() {
        let model = getTaskViewModel()
        delegate?.deleteButtonDidTap(with: model)
    }
}

// MARK: - Private methods
private extension MainCollectionViewCell {
    func getTaskViewModel() -> TaskViewModel {
        guard let title = titleLabel.text, let date = timeLabel.text else {
            return TaskViewModel(title: "0",
                                 datetime: "0",
                                 color: "black",
                                 isBold: false
            )
        }
        // TODO: -
        let model = TaskViewModel(title: title,
                                  datetime: date,
                                  color: textColor,
                                  isBold: isBold
        )
        return model
    }
    
    func setupCell() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        buttonsStackView.addArrangedSubview(editTaskButton)
        buttonsStackView.addArrangedSubview(deleteTaskButton)
        
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(titleLabel)
        bgImageView.addSubview(timeLabel)
        contentView.addSubview(buttonsStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: bgImageView.topAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: bgImageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: -10),
            
            timeLabel.bottomAnchor.constraint(equalTo: bgImageView.bottomAnchor, constant: -15),
            timeLabel.centerXAnchor.constraint(equalTo: bgImageView.centerXAnchor),
        ])
    }
}
