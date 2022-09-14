//
//  TaskCell.swift
//  toDoAppFirebase
//
//  Created by Furkan Erzurumlu on 5.09.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCell(){
        self.cellView.layer.cornerRadius = 10
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
