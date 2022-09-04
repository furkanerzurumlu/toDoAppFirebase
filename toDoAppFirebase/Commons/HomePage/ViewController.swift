//
//  ViewController.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.08.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
 
    @IBOutlet weak var allTaskTableView: UITableView!
    @IBOutlet weak var addTaskText: UITextField!
    @IBOutlet weak var taskAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        
    }
    
    @IBAction func taskAddButton(_ sender: Any) {
        
    }
    
    
    func setLayout(){
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.title = "TO DO"
        
        taskAddButton.setTitle("Add Task", for: .normal)
        taskAddButton.setTitleColor(.white, for: .normal)
        taskAddButton.layer.cornerRadius = 15
        taskAddButton.layer.borderWidth = 2
        taskAddButton.layer.borderColor = UIColor.black.cgColor
        
        
        let viewColor = hexStringToUIColor(hex: "#FCF8E8")
        let buttonColor = hexStringToUIColor(hex: "94B49F")
        let tableViewColor = hexStringToUIColor(hex: "DF7861")
        
        view.backgroundColor = viewColor
        taskAddButton.backgroundColor = buttonColor
        allTaskTableView.backgroundColor = tableViewColor
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

