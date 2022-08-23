//
//  ViewController.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.08.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addToDo))
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.title = "TO DO"
    }
    @objc func addToDo(){
        Router.shared.showAddMissionsVC(navigationController: self.navigationController)
    }

}

