//
//  MapViewController.swift
//  DFS
//
//  Created by Colin Gormley on 12/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton

class MapViewController: UIViewController, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {

    // MARK: Variables
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLiquidFloatingActionButton()
    }
    
    func setupLiquidFloatingActionButton(){
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        
        cells.append(cellFactory("ic_cloud"))
        cells.append(cellFactory("ic_place"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        let image = UIImage(named: "plus")
        bottomRightButton.image = image
 
        self.view.addSubview(bottomRightButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        liquidFloatingActionButton.close()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}