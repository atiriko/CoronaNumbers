//
//  DetailedViewController.swift
//  Corona Numbers
//
//  Created by Atahan on 24/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit
import SwiftChart
import GoogleMobileAds

class DetailedViewController: UIViewController {
    @IBOutlet weak var CountryName: UILabel!
    @IBOutlet weak var CurrentConfirmed: UILabel!
    @IBOutlet weak var CurrentDeaths: UILabel!
    @IBOutlet weak var CurrentRecovered: UILabel!
    @IBOutlet weak var YesterdayConfirmed: UILabel!
    @IBOutlet weak var YesterdayDeaths: UILabel!
    @IBOutlet weak var YesterdayRecovered: UILabel!
    
    @IBOutlet weak var ios12back: UIButton!
    @IBOutlet var chart: Chart!
    
    var countryName = "CountryName"
    var currentConfirmed = 0
    var currentDeaths = 0
    var currentRecovered = 0
    var yesterdayConfirmed = 0
    var yesterdayDeaths = 0
    var yesterdayRecovered = 0
    var confirmeddifference = 0
    var deathsdifference = 0
    var recovereddifference = 0
    var deaths = [Int]()
    var recovered = [Int]()
    var confirmed = [Int]()
    var countries = [String]()
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            ios12back.isHidden = true
            // use the feature only available in iOS 9
            // for ex. UIStackView
        }
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-2092620769473230/9247339751"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        checkdifference()
        fetchdatafromurl()
        
        addBannerViewToView(bannerView)
        

       
   
        
        // Do any additional setup after loading the view.
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
    override func viewDidDisappear(_ animated: Bool) {
        if (self.isBeingDismissed || self.isMovingFromParent) {
  
            AppState.shared.didDismissed = true
                       
        }
    }

    func checkdifference(){
        
        
        confirmeddifference = currentConfirmed - yesterdayConfirmed
        deathsdifference = currentDeaths - yesterdayDeaths
        recovereddifference = currentRecovered - yesterdayRecovered
        
        CountryName.text = countryName
        CurrentConfirmed.text = String(currentConfirmed)
        CurrentDeaths.text = String(currentDeaths)
        CurrentRecovered.text = String(currentRecovered)
        if confirmeddifference > 0 {
            YesterdayConfirmed.text = "\(yesterdayConfirmed) +\(confirmeddifference)"
        }else{
            YesterdayConfirmed.text = "\(yesterdayConfirmed) \(confirmeddifference)"
            
        }
        if confirmeddifference > 0 {
            YesterdayDeaths.text = "\(yesterdayDeaths) +\(deathsdifference)"
        }else{
            YesterdayDeaths.text = "\(yesterdayDeaths) \(deathsdifference)"
            
        }
        if confirmeddifference > 0 {
            YesterdayRecovered.text = "\(yesterdayRecovered) +\(recovereddifference)"
        }else{
            YesterdayRecovered.text = "\(yesterdayRecovered) \(recovereddifference)"
            
        }
    }
    func creategraph(){
        DispatchQueue.main.async {
            let today = Calendar.current.component(.day, from: Date())
            let deathdata = [
                (x: Double(today-6), y: Double(self.deaths[self.deaths.count-1])),
                (x: Double(today-5), y: Double(self.deaths[self.deaths.count-2])),
                (x: Double(today-4), y: Double(self.deaths[self.deaths.count-3])),
                (x: Double(today-3), y: Double(self.deaths[self.deaths.count-4])),
                (x: Double(today-2), y: Double(self.deaths[self.deaths.count-5])),
                (x: Double(today-1), y: Double(self.deaths[self.deaths.count-6])),
                (x: Double(today),   y: Double(self.deaths[self.deaths.count-7]))
            ]
            let recovereddata = [
                (x: Double(today-6), y: Double(self.recovered[self.recovered.count-1])),
                (x: Double(today-5), y: Double(self.recovered[self.recovered.count-2])),
                (x: Double(today-4), y: Double(self.recovered[self.recovered.count-3])),
                (x: Double(today-3), y: Double(self.recovered[self.recovered.count-4])),
                (x: Double(today-2), y: Double(self.recovered[self.recovered.count-5])),
                (x: Double(today-1), y: Double(self.recovered[self.recovered.count-6])),
                (x: Double(today),   y: Double(self.recovered[self.recovered.count-7]))
            ]
            let confirmeddata = [
                (x: Double(today-6), y: Double(self.confirmed[self.confirmed.count-1])),
                (x: Double(today-5), y: Double(self.confirmed[self.confirmed.count-2])),
                (x: Double(today-4), y: Double(self.confirmed[self.confirmed.count-3])),
                (x: Double(today-3), y: Double(self.confirmed[self.confirmed.count-4])),
                (x: Double(today-2), y: Double(self.confirmed[self.confirmed.count-5])),
                (x: Double(today-1), y: Double(self.confirmed[self.confirmed.count-6])),
                (x: Double(today), y: Double(self.confirmed[self.confirmed.count-7]))
            ]
            
            let deathseries = ChartSeries(data: deathdata)
            deathseries.color = UIColor.systemRed
            
            let recoveredseries = ChartSeries(data: recovereddata)
            recoveredseries.color = UIColor.systemGreen
            
            let confirmedseries = ChartSeries(data: confirmeddata)
            confirmedseries.color = UIColor.systemGray
            self.chart.minX = Double(today-6)
            self.chart.maxX = Double(today)
            self.chart.minY = 0
            
            self.chart.labelColor = UIColor.systemGray
           
            
            // Use `xLabels` to add more labels, even if empty
            //chart.xLabels = [Double(today-6), Double(today-5), Double(today-4), Double(today-3), Double(today-2), Double(today-1), Double(today)]
            
            
            // Format the labels with a unit
            
            self.chart.add([deathseries, recoveredseries, confirmedseries])
            
            
        }
        
    }
    
    
    func fetchdatafromurl(){
       
           
        
        let url = "https://pomber.github.io/covid19/timeseries.json"
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            
            if let d = data {
                if let value = String(data: d, encoding: String.Encoding.ascii) {
                    
                    if let jsonData = value.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                           
                            self.usedata(json: json)
                            
                        } catch {
                            ViewController().HandleError(title:"Sorry There Was A Problem", message:"Please try again later", dismissbtn:"Okay", view: self)
                            //error
                            NSLog("ERROR \(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }.resume()
        
    }
    
    func findfavcountryindex(x:String) -> Int{
        
        if let index = countries.firstIndex(of: x){
            return index
        }
        return 0
    }
    func usedata(json:[String : Any]){
        
        
        for (country, _) in json {
            
            countries.append(country)
        }
        
        
        
        let nestedjson = json[countryName] as! [NSDictionary]
        
        for index in 1...7{
            let DataForCountry = nestedjson[nestedjson.count - index]
            

            deaths.append(DataForCountry["deaths"] as? Int ?? 0)
            confirmed.append(DataForCountry["confirmed"] as? Int ?? 0)
            recovered.append(DataForCountry["recovered"] as? Int ?? nestedjson[nestedjson.count - (index + 1)]["recovered"] as? Int ?? 0)
        }
        
        
        creategraph()

        
        
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
