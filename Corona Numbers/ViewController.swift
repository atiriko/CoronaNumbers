//
//  ViewController.swift
//  Corona Numbers
//
//  Created by Atahan on 20/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit
import GoogleMobileAds


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate{
    
    @IBAction func ios12settingsbtn(_ sender: Any) {
    }
    @IBOutlet weak var ios12settigns: UIButton!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    @IBOutlet weak var totalConfirmed: UILabel!
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    
    
    @IBAction func button(_ sender: Any) {
        print(AppState.shared.didDismissed)
    }
    @IBOutlet weak var TableView: UITableView!
    
    var numberOfCounties = 0
    var countries = [String]()
    var deaths = [Int]()
    var recovered = [Int]()
    var confirmed = [Int]()
    var yesterdayDeaths = [Int]()
    var yesterdayRecovered = [Int]()
    var yesterdayConfirmed = [Int]()
    var totalrecovered = 0
    var totaldeaths = 0
    var totalconfirmed = 0
    let defaults = UserDefaults.standard
    var refreshControl = UIRefreshControl()
    let center = UNUserNotificationCenter.current()
    var isdismissed = false
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.presentationController?.delegate = self
        
        if #available(iOS 13.0, *) {
            ios12settigns.isHidden = true
            // use the feature only available in iOS 9
            // for ex. UIStackView
        }
        
        checkifnotificationsenabled()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        TableView.addSubview(refreshControl)
        
        TableView.dataSource = self
        TableView.delegate = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2092620769473230/2365155068")
        let request = GADRequest()
        interstitial.load(request)
        
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //ca-app-pub-3940256099942544/2934735716
        bannerView.adUnitID = "ca-app-pub-2092620769473230/6580265073"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        
        addBannerViewToView(bannerView)
        
        fetchdatafromurl()
        
        
        
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
    
    @objc func refresh(_ sender: Any) {
        
        TableView.reloadData()
        //fetchdatafromurl()
        refreshControl.endRefreshing()
    }
    func findfavcountryindex(x:String){
        
        if let index = countries.firstIndex(of: x){
            self.putfavoritecountryatfront(index: index)
        }
        
    }
    
    
    func putfavoritecountryatfront(index: Int){
        countries.insert(countries[index], at: 0)
        countries.remove(at: index + 1)
        
        deaths.insert(deaths[index], at: 0)
        deaths.remove(at: index + 1)
        
        recovered.insert(recovered[index], at: 0)
        recovered.remove(at: index + 1)
        
        confirmed.insert(confirmed[index], at: 0)
        confirmed.remove(at: index + 1)
        
        yesterdayDeaths.insert(yesterdayDeaths[index], at:0)
        yesterdayDeaths.remove(at: index + 1)
        
        yesterdayConfirmed.insert(yesterdayConfirmed[index], at:0)
        yesterdayConfirmed.remove(at: index + 1)
        
        yesterdayRecovered.insert(yesterdayRecovered[index], at:0)
        yesterdayRecovered.remove(at: index + 1)
        
        DispatchQueue.main.async {
            self.TableView.reloadData()
        }
        
    }
    
    func fetchdatafromurl(){
        countries.removeAll()
        deaths.removeAll()
        recovered.removeAll()
        confirmed.removeAll()
        yesterdayDeaths.removeAll()
        yesterdayRecovered.removeAll()
        yesterdayConfirmed.removeAll()
        
        
        let url = "https://pomber.github.io/covid19/timeseries.json"
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            
            if let d = data {
                if let value = String(data: d, encoding: String.Encoding.ascii) {
                    
                    if let jsonData = value.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                            
                            if let arr = json["rows"] as? [[String: Any]] {
                                debugPrint(arr)
                                
                                
                            }
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
    func checkifnotificationsenabled(){
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                }
                // Notification permission has not been asked yet, go for it!
            } else if settings.authorizationStatus == .denied { self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                }
                DispatchQueue.main.async {
                    ViewController().HandleError(title:"Notifications are disabled", message:"Please turn on notifications at settings", dismissbtn:"Okay", view: self)
                    
                }
                
                // Notification permission was previously denied, go to settings & privacy to re-enable
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
            }
        })
    }
    
    func usedata(json:[String : Any]){
        
        
        for (country, _) in json {
            
            numberOfCounties += 1
            countries.append(country)
            
            let nestedjson = json[country] as! [NSDictionary]
            
            let newestDataForCountry = nestedjson[nestedjson.count - 1]
            let previousDataForCountry = nestedjson[nestedjson.count - 2]
            
            if (newestDataForCountry["recovered"] as? Int) == nil{
                
                print(nestedjson.count)
                for numberoftries in 1...nestedjson.count{
                    if (nestedjson[nestedjson.count - numberoftries]["recovered"] as? Int != nil){
                        recovered.append(nestedjson[nestedjson.count - numberoftries]["recovered"] as! Int)
                        yesterdayRecovered.append(nestedjson[nestedjson.count - (numberoftries + 1)]["recovered"] as! Int)
                        
                        
                        break
                        
                    }else{
                        if numberoftries == nestedjson.count{
                            recovered.append(newestDataForCountry["recovered"] as? Int ?? 0)
                            yesterdayRecovered.append(previousDataForCountry["recovered"] as? Int ?? 0)
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            }else{
            recovered.append(newestDataForCountry["recovered"] as? Int ?? 0)
                                       yesterdayRecovered.append(previousDataForCountry["recovered"] as? Int ?? 0)
            }
            // print(recovered.count)
            
            deaths.append(newestDataForCountry["deaths"] as? Int ?? previousDataForCountry["deaths"] as? Int ?? 0)
            confirmed.append(newestDataForCountry["confirmed"] as? Int ?? previousDataForCountry["confirmed"] as? Int ?? 0)
            // print(deaths.count)
            // print(confirmed.count)
            
            //  recovered.append(newestDataForCountry["recovered"] as? Int ?? previousDataForCountry["recovered"] as? Int ?? 0)
            
            yesterdayDeaths.append(previousDataForCountry["deaths"] as? Int ?? 0)
            yesterdayConfirmed.append(previousDataForCountry["confirmed"] as? Int ?? 0)
            
        }
        print(deaths.count)
        print(recovered.count)
        totalrecovered = recovered.reduce(0, +)
        totaldeaths = deaths.reduce(0, +)
        totalconfirmed = confirmed.reduce(0, +)
        
        
        

            DispatchQueue.main.async {
            self.totalDeaths.text = String(self.clearbignumbers(x: self.totaldeaths))
            self.totalRecovered.text = String(self.clearbignumbers(x: self.totalrecovered))
            self.totalConfirmed.text = String(self.clearbignumbers(x: self.totalconfirmed))
            
        }
        
        sortarrays()
        
        
    }
    func sortarrays(){
        //It first sorts confirmed cases descending
        //Than it maps all the other arrays
        
        let offsets = confirmed.enumerated().sorted {$0.1>$1.1}.map { $0.offset }
        
        // Use map on the array of ordered offsets to order the other arrays
        let sorted_confirmed = offsets.map { confirmed[$0] }
        let sorted_countries = offsets.map { countries[$0] }
        let sorted_deaths = offsets.map { deaths[$0] }
        let sorted_recovered = offsets.map { recovered[$0] }
        let yesterday_sorted_confirmed = offsets.map { yesterdayConfirmed[$0] }
        let yesterday_sorted_deaths = offsets.map { yesterdayDeaths[$0] }
        let yesterday_sorted_recovered = offsets.map { yesterdayRecovered[$0] }
        
        deaths = sorted_deaths
        confirmed = sorted_confirmed
        countries = sorted_countries
        recovered = sorted_recovered
        yesterdayRecovered = yesterday_sorted_recovered
        yesterdayConfirmed = yesterday_sorted_confirmed
        yesterdayDeaths = yesterday_sorted_deaths
        
        if let favoriteCountry = defaults.string(forKey: "favoriteCountry"){            findfavcountryindex(x: favoriteCountry)
        }
        
        DispatchQueue.main.async {
            self.TableView.reloadData()
        }
    }
    
    func clearbignumbers(x: Int) -> String{
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:x))
        
        return formattedNumber!
    }
    func sendnotification(){
        
        
        let content = UNMutableNotificationContent()
        content.title = "There Is An Update"
        content.body = "The numbers have been updated. Check out latest numbers!"
        content.sound = UNNotificationSound.default
        
        
        var firstUpdate = DateComponents()
        firstUpdate.timeZone = TimeZone(identifier: "UTC")
        firstUpdate.hour = 5
        firstUpdate.minute = 15
        
        var secondUpdate = DateComponents()
        secondUpdate.timeZone = TimeZone(identifier: "UTC")
        secondUpdate.hour = 13
        secondUpdate.minute = 15
        
        
        var thirdUpdate = DateComponents()
        thirdUpdate.timeZone = TimeZone(identifier: "UTC")
        thirdUpdate.hour = 21
        thirdUpdate.minute = 15
        
        let firstTrigger = UNCalendarNotificationTrigger(dateMatching: firstUpdate, repeats: true)
        
        let secondTrigger = UNCalendarNotificationTrigger(dateMatching: secondUpdate, repeats: true)
        
        let thirdrigger = UNCalendarNotificationTrigger(dateMatching: thirdUpdate, repeats: true)
        
        
        let request1 = UNNotificationRequest(identifier: "corona1", content: content, trigger: firstTrigger)
        let request2 = UNNotificationRequest(identifier: "corona2", content: content, trigger: secondTrigger)
        let request3 = UNNotificationRequest(identifier: "corona3", content: content, trigger: thirdrigger)
        
        
        center.add(request1)
        center.add(request2)
        center.add(request3)
        
        
    }
    func HandleError(title:String, message:String, dismissbtn:String, view: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: dismissbtn, style: UIAlertAction.Style.default))
        view.present(alertController, animated: true,completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfCounties - 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableViewCell
        
        cell.country.text = countries[indexPath.item]
        cell.confirmed.text = String(clearbignumbers(x: confirmed[indexPath.item]))
        cell.death.text = String(clearbignumbers(x: deaths[indexPath.item]))
        cell.recovered.text = String(clearbignumbers(x: recovered[indexPath.item]))
        
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if #available(iOS 13.0, *) {
            if(AppState.shared.didDismissed){
                       if interstitial.isReady {
                           interstitial.present(fromRootViewController: self)
                           AppState.shared.didDismissed = false
                       }
                   }
               } else {
                       if interstitial.isReady {
                           interstitial.present(fromRootViewController: self)
                           AppState.shared.didDismissed = false
                       }
                   
                   // Fallback on earlier versions
               }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailedView") as! DetailedViewController
        
        vc.countryName = countries[indexPath.row]
        vc.currentConfirmed = confirmed[indexPath.row]
        vc.currentDeaths = deaths[indexPath.row]
        vc.currentRecovered = recovered[indexPath.row]
        
        vc.yesterdayDeaths = yesterdayDeaths[indexPath.row]
        vc.yesterdayConfirmed = yesterdayConfirmed[indexPath.row]
        vc.yesterdayRecovered = yesterdayRecovered[indexPath.row]
        //  vc.numberOfItemsInBasket = self.stocks.count
        self.present(vc,animated: true, completion: nil)
    }
    
    func addtofavorites(index: Int){
        defaults.set(countries[index], forKey: "favoriteCountry")
        
        
        countries.insert(countries[index], at: 0)
        countries.remove(at: index + 1)
        
        deaths.insert(deaths[index], at: 0)
        deaths.remove(at: index + 1)
        
        recovered.insert(recovered[index], at: 0)
        recovered.remove(at: index + 1)
        
        confirmed.insert(confirmed[index], at: 0)
        confirmed.remove(at: index + 1)
        
        TableView.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let notifyAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            self.sendnotification()
            complete(true)
        }
        
        if #available(iOS 13.0, *) {
            notifyAction.image = UIImage(systemName: "bell.fill")
        } else {
            
            notifyAction.image = imageWithImage(image:UIImage(named: "Bell Fill.png")!, scaledToSize:CGSize(width: 30, height: 30))
            // Fallback on earlier versions
        }
        notifyAction.backgroundColor = .systemGray
        
        
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            if self.defaults.string(forKey: "favoriteCountry") != nil{            self.defaults.removeObject(forKey: "favoriteCountry")
                self.fetchdatafromurl()
            }else{
                self.addtofavorites(index: indexPath.row)
            }
            complete(true)
        }
        if self.defaults.string(forKey: "favoriteCountry") != nil{
            if(indexPath.row == 0){
                if #available(iOS 13.0, *) {
                    favoriteAction.image = UIImage(systemName: "star.fill")
                    favoriteAction.backgroundColor = UIColor.systemYellow

                } else {
                    favoriteAction.image = imageWithImage(image:UIImage(named: "Star Fill.png")!, scaledToSize:CGSize(width: 30, height: 30))
                     favoriteAction.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 10/255, alpha: 1)
                }

               
            }
            else{
                if #available(iOS 13.0, *) {
                    favoriteAction.image = UIImage(systemName: "star")
                } else {
                    favoriteAction.image = imageWithImage(image:UIImage(named: "Star.png")!, scaledToSize:CGSize(width: 30, height: 30))
                    }
                }
                if #available(iOS 13.0, *) {
                    favoriteAction.backgroundColor = .systemGray2
                } else {
                    favoriteAction.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 156/255, alpha: 1)
                }
            }
            
        else{
            if #available(iOS 13.0, *) {
                favoriteAction.image = UIImage(systemName: "star")
            } else {
                favoriteAction.image = imageWithImage(image:UIImage(named: "Star.png")!, scaledToSize:CGSize(width: 30, height: 30))
            }
            if #available(iOS 13.0, *) {
                favoriteAction.backgroundColor = .systemGray2
            } else {
                favoriteAction.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 156/255, alpha: 1)
            }
        }
        
        
        
        return UISwipeActionsConfiguration(actions:  [notifyAction,favoriteAction])
        
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}

