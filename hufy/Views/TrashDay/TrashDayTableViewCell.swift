//
//  TrashDayTableViewCell.swift
//  hufy
//
//  Created by branch10480 on 2020/10/11.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class TrashDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inChargeOfImageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 再利用時にもともと購読されていたものを破棄するため、新オブジェクトで置き換える
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        imageView?.superview?.layer.masksToBounds = true
        imageView?.superview?.layer.cornerRadius = imageViewHeight.constant / 2
    }
    
    func set(_ day: TrashDay, me: UserElementConvertible, partner: UserElementConvertible?) {
        switch day.dayType {
        case .sun?:
            dayLabel.textColor = .sunday
        case .sat?:
            dayLabel.textColor = .saturday
        default:
            if #available(iOS 13.0, *) {
                dayLabel.textColor = .label
            } else {
                dayLabel.textColor = .darkText
            }
        }
        dayLabel.text = day.dayType?.title
        descriptionLabel.text = day.title
        if let partner = partner, partner.id == day.inChargeOf {
            imageView?.kf.setImage(with: URL(string: partner.iconURL ?? ""))
        } else {
            imageView?.kf.setImage(with: URL(string: me.iconURL ?? ""))
        }
    }
    
}
