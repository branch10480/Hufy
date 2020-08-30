//
//  TodoTableViewCell.swift
//  hufy
//
//  Created by branch10480 on 2020/08/29.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkboxView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        // checkbox
        checkboxView.layer.borderWidth = 1
        checkboxView.layer.borderColor = UIColor.checkMarkNormal.cgColor
        checkboxView.layer.cornerRadius = 4
        // imageView
        checkImageView.image = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
    }
    
    func set(_ todo: Todo) {
        textView.text = todo.title
        checkImageView.tintColor = todo.isDone ? .checkMarkActive : .checkMarkNormal
    }
}
