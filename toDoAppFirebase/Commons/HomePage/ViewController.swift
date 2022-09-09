//
//  ViewController.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.08.2022.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController{
    
    
    
    // Read the timestamp by converting to UniqueID.
    
    @IBOutlet weak var allTaskTableView: UITableView!
    @IBOutlet weak var addTaskText: UITextField!
    @IBOutlet weak var taskAddButton: UIButton!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        allTaskTableView.dataSource = self
        allTaskTableView.delegate = self
        
        allTaskTableView.register(TaskCell.nibName, forCellReuseIdentifier: TaskCell.identifier)
        
    }
    
    @IBAction func taskAddButton(_ sender: Any) {
        
        let object: [String: Any] = [
            "Task": "\(String(describing: self.addTaskText.text!))" as NSObject,
            "Time": "\(taskTime())"
        ]
        database.child("\(generateUniqueID())").setValue(object)
        addTaskText.text = ""
    }
    
    func setLayout(){
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.title = "TO DO"
        
        taskAddButton.setTitle("Add Task", for: .normal)
        taskAddButton.setTitleColor(.white, for: .normal)
        taskAddButton.layer.cornerRadius = 15
        taskAddButton.layer.borderWidth = 2
        taskAddButton.layer.borderColor = UIColor.black.cgColor
        
        allTaskTableView.separatorColor = .white
        
        addTaskText.placeholder = "Add Task"
        addTaskText.textAlignment = .center
        
        let color1 = hexStringToUIColor(hex: "#FCF8E8")
        let color2 = hexStringToUIColor(hex: "94B49F")
        view.backgroundColor = color1
        taskAddButton.backgroundColor = color2
        allTaskTableView.backgroundColor = color2
        
    }
    func generateUniqueID() -> String{
        let uuid = UUID().uuidString
        return uuid
    }
    func taskTime() -> String{
        let today = Date()
        
        let hours = (Calendar.current.component(.hour, from: today))
        let minutes = (Calendar.current.component(.minute, from: today))
        let seconder = (Calendar.current.component(.second, from: today))
        let date = (Calendar.current.component(.day, from: today))
        let mounth = (Calendar.current.component(.month, from: today))
        let year = (Calendar.current.component(.year, from: today))
        
        let time = "\(date).\(mounth).\(year) - \(hours):\(minutes):\(seconder) "
        
        return time
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allTaskTableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.selectionStyle = .none
        let colorCell = hexStringToUIColor(hex: "#FCF8E8")
        cell.cellView.backgroundColor = colorCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete your item here and reload table view
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_,_,completionHandler) in
            //delete the item here
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
