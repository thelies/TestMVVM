//
//  ItemCell.swift
//  TestMVVM
//
//  Created by Le Ngoc HOAN on 6/9/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import UIKit
import RxSwift

class ItemCell: UITableViewCell {
    static let identifier = "ItemCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
