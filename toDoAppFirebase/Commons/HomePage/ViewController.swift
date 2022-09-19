//
//  ViewController.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.08.2022.
//

import UIKit


class ViewController: UIViewController{
    
    var viewModel = HomePageVM()
    
    @IBOutlet weak var allTaskTableView: UITableView!
    @IBOutlet weak var addTaskText: UITextField!
    @IBOutlet weak var taskAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshTableView = { [weak self] in
            self?.allTaskTableView.reloadData()
        }
        viewModel.delegate = self
        setLayout()
        viewModel.observingTheData()
        
        allTaskTableView.dataSource = self
        allTaskTableView.delegate = self
        
        allTaskTableView.register(TaskCell.nibName, forCellReuseIdentifier: TaskCell.identifier)
        
    }
    
    @IBAction func taskAddButton(_ sender: Any) {
        
        viewModel.addTask(text: addTaskText.text ?? "")
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
        return viewModel.taskList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allTaskTableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.selectionStyle = .none
        let colorCell = hexStringToUIColor(hex: "#FCF8E8")
        cell.cellView.backgroundColor = colorCell
        
        let task: TaskModel
        
        task = viewModel.taskList[indexPath.row]
        print(task.task as Any)
        
        cell.taskLabel.text = "\(task.task ?? "")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.taskList[indexPath.row]
        
        let alertController = UIAlertController(title: task.task, message: "Give new values to update ", preferredStyle: .alert)
        alertController.addTextField()
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { [unowned self] (data) in
            
            let id = task.id
            
            let task = alertController.textFields?[0].text

            self.viewModel.updateTask(id: id!, task: task!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in
            
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_,_,completionHandler) in
            //delete the item here
            let task: TaskModel
            task = self.viewModel.taskList[indexPath.row]
            
            self.viewModel.deleteTask(id:task.id!)
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension ViewController: HomePageVMDelegate {
    func refreshTableView() {
        self.allTaskTableView.reloadData()
    }
    
    
}
