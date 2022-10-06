//
//  imagesGalleriesTableViewCell.swift
//  Project_5_ImageGallery
//
//  Created by Victor on 02.06.2022.
//

import UIKit

class ImagesGalleriesTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var editText: (String) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ImagesGalleriesTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editText(textField.text ?? "")
        textField.isUserInteractionEnabled = false
        textField.endEditing(true)
        return true
    }
}
