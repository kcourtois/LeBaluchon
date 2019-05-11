//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var userTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userTextView.textColor = UIColor.lightGray
        resultTextView.textColor = UIColor.lightGray
    }

    @IBAction func translateText() {
        userTextView.resignFirstResponder()
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Entrez votre texte ici"
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        userTextView.resignFirstResponder()
    }
}
