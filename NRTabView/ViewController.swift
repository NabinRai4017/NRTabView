//
//  ViewController.swift
//  NRTabView
//
//  Created by nabinrai on 11/6/17.
//  Copyright © 2017 nabin. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nrTabView: NRTabView!
    @IBOutlet weak var label: UILabel!
    
    let nrTabView2 = NRTabView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nrTabView2.frame = CGRect(x: 10, y: 100, width: 300, height: 50)
        nrTabView2.backgroundColor = .yellow
        nrTabView2.delegate = self
        nrTabView2.buttonShape = .square
        nrTabView2.numberOfButtons = 8
        nrTabView.delegate = self
        nrTabView.numberOfButtons = 5
        nrTabView.buttonsColor = .purple
        nrTabView.selectedBubbleColor = .black
        
        self.view.addSubview(nrTabView2)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
}

extension ViewController: NRTabViewDelegate{
    
    
    func didSelect(_ button: UIButton, ofIndex index: Int) {
       label.text = "You pressed Button\(index+1)."
    }
    
    
    
    
    
    
    
}

