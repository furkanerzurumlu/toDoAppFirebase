//
//  HomePageVM.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 18.09.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol HomePageVMDelegate {
    func refreshTableView()
}

class HomePageVM {
    
    var delegate: HomePageVMDelegate?
    
    var refreshTableView: (() -> Void)?
    
    
    private let database = Database.database().reference()
    
    var taskList = [TaskModel]()
    var refTask: DatabaseReference!
    
    
    init() {
        refTask = database.ref.child("task")
    }
    
    func addTask(text: String){
        let key = refTask.childByAutoId().key
        
        let task = ["ID":key,"Task": text,
                    "Time": "\(taskTime())" as String]
        refTask.child(key ?? "").setValue(task)
        
        
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
    
    func observingTheData(){
        refTask = database.ref.child("task")
        refTask.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.taskList.removeAll()
                
                for tasks in snapshot.children.allObjects as! [DataSnapshot] {
                    let taskObject = tasks.value as? [String: AnyObject]
                    let taskName = taskObject?["Task"]
                    let taskID = taskObject?["ID"]
                    
                    let task = TaskModel(id: taskID as! String?, task: taskName as! String?)
                    
                    self.taskList.append(task)
                    print(self.taskList.first ?? "")
                }
                self.refreshTableView?()
                self.delegate?.refreshTableView()
            }
        })
    }
    func deleteTask(id: String){
        refTask.child(id).setValue(nil)
    }
    
    func updateTask(id: String,task: String){
        let task = ["ID":id,"Task": task]
        
        refTask.child(id).setValue(task)
        
        
    }
    
}
