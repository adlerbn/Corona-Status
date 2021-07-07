//
//  Extensions.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit

//MARK: - Dismiss Keyboard
extension UIViewController {
    func addGesture() {
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        self.view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
