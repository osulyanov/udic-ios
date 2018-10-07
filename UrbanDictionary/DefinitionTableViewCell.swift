//
//  DefinitionTableViewCell.swift
//  UrbanDictionary
//
//  Created by Oleg Sulyanov on 30/09/2018.
//  Copyright © 2018 Oleg Sulyanov. All rights reserved.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelWord: UILabel!
    @IBOutlet weak var labelDefinition: UILabel!
    @IBOutlet weak var labelExample: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
