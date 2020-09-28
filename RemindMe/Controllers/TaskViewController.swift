//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UIViewController {
    
    let ref = Database.database().reference(withPath: "task-items")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testBackground()
    }
    
    private func testBackground() {
        view.backgroundColor = .blue
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

