//
//  CustomVC.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 31.01.2024.
//

import UIKit

class CustomVC: UIViewController {
  func setupNavBar(titleName: String) {
    customNavBarTitle(titleName: titleName)
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.systemTeal
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
  }
  
  func setupNavBarWithBackButton(titleName: String) {
    customNavBarTitle(titleName: titleName)
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.systemTeal
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    navigationController?.navigationBar.topItem?
      .backBarButtonItem = UIBarButtonItem(title: "",
                                           style: .plain,
                                           target: nil,
                                           action: nil
      )
  }
  
  func setupNavBarWithoutTitle() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.systemTeal
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  func customNavBarTitle(titleName: String) {
    let label = UILabel()
    label.text = titleName
    label.font = UIFont(name: Fonts.OfficSanExtraBold,
                        size: Constants.customNavBarTitleFontSize
    )
    label.textColor = .white
    navigationItem.titleView = label
  }
  
  enum Constants {
    static let customNavBarTitleFontSize: CGFloat = 21
  }
}

