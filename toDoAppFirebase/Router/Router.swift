//
//  Router.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 23.08.2022.
//

import Foundation
import UIKit

final class Router {
    
    static var shared: Router = Router()
    
    func showAddMissionsVC(navigationController: UINavigationController?){
        let addMissionVC = addMissions.instantiate(storyboard: .addMissions)
        navigationController?.pushViewController(addMissionVC, animated: true)
    }
    
}
