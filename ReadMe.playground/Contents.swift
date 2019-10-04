/*:
  ![Playground icon](PED_technology.png)
 # ASSESSMENT TASK – WEATHER APP
 
 ## General notes
 
 The following project is designed to assess the candidate's abilities to create an iOS app
 
 ** **
 
 ## The project

 OpenWeatherMap is a service that allows you to obtain weather data for a specific location.
 
 You'll create an app that relais on this API. The app should allow you to run a search using an UISearchBar or an UITextField. The obtained data (weather, wind, temperature, and other data) should be displayed on an UITableView (or UICollectionView depending on the graphics to be used).
 
 Among the data that the API can return there is also the geographic coordinates of the location: you will have to give the option to show the location on a MKMapView dropping a Pin.
 
 The project includes some graphic assets that will be useful for graphic design, see Assets.xcassets
 
** **
 
 ## The APIs
 
 **EndPoint:**
 http://api.openweathermap.org/data/2.5/weather
 
 **ApiKey:**
 d73ebe7666213fce3740edab89797838
 
 **Query Elements:**
 * **q**:   City for which the weather is requested. Ex: London, Rome, Los Angeles ...
 * **apikey**:   Access key to make the request.
 
  **Request sample:**
 
 [http://api.openweathermap.org/data/2.5/weather?q=London&apikey=d73ebe7666213fce3740edab89797838](http://api.openweathermap.org/data/2.5/weather?q=London&apikey=d73ebe7666213fce3740edab89797838)
 
 **Response sample:**
 
 ```
 {
  "coord": {
    "lon": -0.13,
    "lat": 51.51
  },
  "weather": [
    {
      "id": 300,
      "main": "Drizzle",
      "description": "light intensity drizzle",
      "icon": "09d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 280.32,
    "pressure": 1012,
    "humidity": 81,
    "temp_min": 279.15,
    "temp_max": 281.15
  },
  "visibility": 10000,
  "wind": {
    "speed": 4.1,
    "deg": 80
  },
  "clouds": {
    "all": 90
  },
  "dt": 1485789600,
  "sys": {
    "type": 1,
    "id": 5091,
    "message": 0.0103,
    "country": "GB",
    "sunrise": 1485762037,
    "sunset": 1485794875
  },
  "id": 2643743,
  "name": "London",
  "cod": 200
}
 ```
 
 **ATTENTION***: The url for the request is in HTTP
 
 ** **
 
 Concerning the graphic design, you will find below some examples from which to draw inspiration.
 
 ## The technical requirements

 - Swift 4+
 - CoreData
 - Alamofire
 - CocoaPods
 - [Swiftlint](https://github.com/realm/SwiftLint)
 - Unit Testing
 - AutoLayout
 
 - Note:
 Be aware of the auto-layout, you must take into account the different display sizes or future iPad alignment.
 
 ### CoreData
 
 Implement a CoreData structure that save HTTP requests as follows:
 
 * **Requests that will expire**: all requests about weather, wind, temperature will be saved on local db and next requests (before expire date - 1 hour) gets data from local
 * **Requests persistent**: all requests about geographic coordinates of the location will be saved on local so that all next requests get data from local
 
 ## Nice-to-have
 
 - UI testing
  
 ** **
 
 Share the project in a private repository on Bitbucket or Gitlab.
 
 Happy coding :)
 
 ![Example 1](Example-1.jpg)
 ![Example 2](Example-2.png)
 ![Example 3](Example-3.png)
 ![Example 4](Example-4.png)
 ![Example 5](Example-5.png)
 ![Example 6](Example-6.jpg)

 */
