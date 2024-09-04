
import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTeckField: UITextField!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTeckField.delegate = self
        //konum yöneticisini çağırır
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

  
}

extension WeatherViewController : UITextFieldDelegate{


    @IBAction func searchPress(_ sender: UIButton) {
        searchTeckField.endEditing(true)
        print(searchTeckField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTeckField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTeckField.text != "" {
            return true
        }
        else {
            searchTeckField.placeholder = "type something "
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTeckField.text{
            
            weatherManager.fetchWeather(cityName: city)
            
        }
    }
    
    
}
extension WeatherViewController : WeatherManagerDelegate{
    func updateWeather(_ weatherManager: WeatherManager , weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
        
    }
    func didFailWithError(error : Error){
        print("error")
    }
}
extension WeatherViewController : CLLocationManagerDelegate{

    @IBAction func locationPress(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    //konum güncellemesi alındığı zaman çağrılır
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeatherLogation(latitude: lat, longitude: lon)
        }
    }
    //konum izinleri değiştiğinde çağrılır
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    //konum güncelleme almadığında çağrılır
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Konum alınamadı: \(error.localizedDescription)")
        }
}

