//
//  ViewController.swift
//  BlueToothKeyboard
//
//  Created by 王志邦 on 2018/12/1.
//  Copyright © 2018 EdwardMartin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func add(a:Int, b:Int)->Int{
        return a + b
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(add(a: 10, b: 20))
    }


}

