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
    
    @IBOutlet weak var allTaskTableView: UITableView!
    @IBOutlet weak var addTaskText: UITextField!
    @IBOutlet weak var taskAddButton: UIButton!
    
    
    
    private let database = Database.database().reference()
    
    var taskList = [TaskModel]()
    var refTask: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refTask = database.ref.child("task")
        setLayout()
        observingTheData()
        
        allTaskTableView.dataSource = self
        allTaskTableView.delegate = self
        
        allTaskTableView.register(TaskCell.nibName, forCellReuseIdentifier: TaskCell.identifier)
        
    }
    
    @IBAction func taskAddButton(_ sender: Any) {
        
        addTask()
//        let object: [String: Any] = [
//            "Task": "\(String(describing: self.addTaskText.text!))" as NSObject,
//            "Time": "\(taskTime())"
//        ]
//        database.childByAutoId().setValue(object)
//        addTaskText.text = ""
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
    func addTask(){
        let key = refTask.childByAutoId().key
        
        let task = ["ID":key,"Task": addTaskText.text! as String,
                    "Time": "\(taskTime())" as String]
        refTask.child(key ?? "").setValue(task)
        
        addTaskText.text = ""
        
    }
    func observingTheData(){
        refTask.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.taskList.removeAll()
                
                for tasks in snapshot.children.allObjects as! [DataSnapshot] {
                    let taskObject = tasks.value as? [String: AnyObject]
                    let taskName = taskObject?["taskName"]
                    let taskID = taskObject?["id"]
                    
                    let task = TaskModel(id: taskID as! String?, task: taskName as! String?)
                    
                    self.taskList.append(task)
                }
                self.allTaskTableView.reloadData()
            }
        })
    }
    func deleteTask(id:String){
            refTask.child(id).setValue(nil)
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
        return taskList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allTaskTableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.selectionStyle = .none
        let colorCell = hexStringToUIColor(hex: "#FCF8E8")
        cell.cellView.backgroundColor = colorCell
        
        let task: TaskModel
        
        task = taskList[indexPath.row]
        print(task.task as Any)
        
        cell.taskLabel.text = "\(String(describing: task.task))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            self.taskList.remove(at: indexPath.row)
            self.allTaskTableView.beginUpdates()
            self.allTaskTableView.deleteRows(at: [indexPath], with: .automatic)
            self.allTaskTableView.endUpdates()
//            let task = self.taskList[indexPath.row]
//            self.deleteTask(id: task.id!)
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
