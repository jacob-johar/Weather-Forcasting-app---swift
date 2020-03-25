                         
                                  WEATHER FORCASTING APP
                                 
                   This app gives the current climatic condition of regions.
This app uses http://openweathermap.org/api for getting the updated weather conditions.
App consists of 4 view controllers namely
  -WeatherViewController
  -MapViewController
  -TableViewController
  -LocationSelectorViewController

                                     APP DETAILS
:MapView

-The app starts with a tabView with the mapView. For obtaining weather details of any location on the map, Long press on the respective location until a pin drops on that location. Clicking on the pin gives a detailed weather report of that particular location. 

:ListView

- When the user selects the listView, It shows the history ie the list of all the places on which the user has dropped the pin along with the current weather conditions  and Temperature of that location. Clicking a cell on the listView enables the user to a view which gives detailed information of the  region. If a particular 
 cell has no weather data press the refresh button to update the cell with new data

:For Deletion

-To delete a particualar data from the View. The user has to select the ListView and longPress the particular place which the user no longer needs. After deleting the updation takesplace on the map too.

:To Search A Particular Area

-If the user cannot find the location on the mapView. The user can select the listView and touch the add button(+) on the Top right corner of the view. It displays a textField in which the user can type an area for which he wants the weather information and press the search button. The weather Information for that particular area  gets updated in the listView and the MapView.

:IMP NOTE

-The app works only when the internet is ON.
