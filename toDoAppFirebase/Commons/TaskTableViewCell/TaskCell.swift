//
//  TaskCell.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 5.09.2022.
//

import UIKit

class TaskCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TaskCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    static var nibName: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
