

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
        
    
}
struct WeatherManager{
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=034dcd59a1172d89b724f367a648a2c2&units=metric"
    func fetchWeatherLogation(latitude:CLLocationDegrees , longitude:  CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString )
        print(urlString)

    }
    func fetchWeather(cityName:String ){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    func performRequest(urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.updateWeather(self, weather: weather)
                        print(weather)
                    }
                
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch{
            print(error)
            return nil
        }
    }

}
