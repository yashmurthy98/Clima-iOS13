//
//  ResultViewController.swift
//  Clima
//
//  Created by Yash Murthy on 13/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    var temperatureValue: String?
    var conditionName: String?
    var cityName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureLabel.text = temperatureValue
        cityLabel.text = cityName
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
