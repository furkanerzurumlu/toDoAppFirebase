//
//  TaskModel.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.09.2022.
//

import Foundation

class TaskModel {
    
    var id: String?
    var task: String?
    
    init(id: String?,task: String?){
        self.id = id
        self.task = task
    }
}
