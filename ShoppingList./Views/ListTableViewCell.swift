//
//  ListTableViewCell.swift
//  ShoppingList.
//
//  Created by Anthony Torres on 11/15/19.
//  Copyright © 2019 Anthony Torres. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    func checkBoxButtonTapped(_ sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabelName: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    var delegate: ListTableViewCellDelegate?

    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        guard let delegate = delegate
            else { return }
        
        delegate.checkBoxButtonTapped(self)
    }
    
    func updateView(list: ShoppingList) {
        itemLabelName.text = list.name
        let buttonImage = UIImage(named: list.isChecked ? "complete" : "incomplete")
        checkBoxButton.setImage(buttonImage, for: .normal)
    }
}
