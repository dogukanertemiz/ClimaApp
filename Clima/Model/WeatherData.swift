
import Foundation
//decobale json formatındaki kodu çözüyor.
struct WeatherData : Codable{
    let name : String
    let main : Main
    let weather : [Weather]
    
}
struct Main : Codable{
    let temp : Double
}
struct Weather : Codable{
    let description : String
    let id : Int
}
struct coord : Codable{
    let lon : Double
    let lat : Double
}
