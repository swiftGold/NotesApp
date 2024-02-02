//
//  ViewController.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import UIKit

// MARK: - MainViewControllerProtocol
protocol MainViewControllerProtocol: UIViewController {
    func showTasks(with array: [TaskViewModel])
}

class MainViewController: CustomVC {
    // MARK: - UI
    private let backgroundImage: UIImageView = {
        let image = UIImage(named: Images.refrigerator)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout
        )
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 12) / 2 ,
                                 height: 150
        )
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: Names.mainCollectionViewCell
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.title = Names.addTaskButtonText
        button.configuration?.baseForegroundColor = .systemPurple
        button.configuration?.image = UIImage(systemName: Images.book)
        button.configuration?.imagePadding = 10
        button.configuration?.imageColorTransformer = .monochromeTint
        
        return button
    }()
    
    // MARK: - Variables
    var presenter: MainPresenterProtocol?
    var tasksArray: [TaskViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - @objc methods
    @objc
    private func addTaskButtonTapped() {
        presenter?.addTask()
    }
}

// MARK: - UICollectionViewDelegate impl
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapCell(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource impl
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.mainCollectionViewCell, for: indexPath) as? MainCollectionViewCell else { fatalError() }
        cell.configureCell(with: tasksArray[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - MainCollectionViewCellDelegate impl

extension MainViewController: MainCollectionViewCellDelegate {
    func editButtonDidTap(with model: TaskViewModel) {
        presenter?.editButtonTapped(with: model)
    }
    
    func deleteButtonDidTap(with model: TaskViewModel) {
        presenter?.deleteButtonTapped(with: model)
    }
}

// MARK: - MainViewControllerProtocol impl
extension MainViewController: MainViewControllerProtocol {
    func showTasks(with array: [TaskViewModel]) {
        tasksArray = array
        collectionView.reloadData()
    }
}

// MARK: - private methods
private extension MainViewController {
    func setupViewController() {
        addSubviews()
        setConstraints()
        
        presenter?.viewDidLoad()
    }
    
    func addSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(collectionView)
        view.addSubview(addTaskButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -10),
            
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.widthAnchor.constraint(equalToConstant: 180),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
