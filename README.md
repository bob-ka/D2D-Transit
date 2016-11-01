D2D Transit - Summary

     How to run the app?
Clone the repository.  
Run "pod install" in the terminal - it might ask you to update the cocoapods repo "pod repo update".  
Xcode 8 asks you to convert files to swift 3.  
Clean & build.  
It might show an error on something called SVGKLogVerbose. Just comment out that line.  
Run.  

     Libraries Used:


Google Maps SDK   
SVGKit  
AKSideMenu  

     The app consists of 4 main Pages [ RoutesViewController - RoutesDetailViewController - FavouritesTableViewController - ProvidersTableViewController]

RoutesViewController:   
It shows the map of Berlin, though you could search for any two positions [ origin(from) - destination(to)] and it would draw the path between them and center the map to show that path. [Minumum functionality being not connected to any backend or transport service]   
It Displays the routes from the JSON file showing provider’s type and vehicle’s name or number if any. It shows the price of the transportation.   
The Get Going Label or Time Remaining Label is  [Relax (> 20 minutes) - Get Going (< 20 minutes) -  Missed (< 0 minutes)]. All would appear missed because the date is old.   
The legend view shows the different transportation methods.

RoutesDetailViewController:   
It shows the route on the map
The ability to add the route to favourites.
A tableView showing a route’s starting points, stops and destination.

FavouritesTableViewController:  - self explanatory   
Ability to Delete the favorite by swiping the cell and have that persisted.

Note: -  Datamanager : a single class to handle all saved Data and call global helper methods.

     Q:  How did I go about organising my work and setting up my priorities?
A:   I’ve written down all the main things that needs to be done and I gave each one of them a priority.
      i.e

Route’s Detail page - collapsable table cells [High Priority]   
Parsing Json File and outputing a usable object made up of several user defined objects [High Priority]   
Routes page - google autocomplete and searchbar [medium priority]   
Favourites Page - Providers Page [ Low Priority]  
...   

I put down a list of topics to include in the project such as:

Folders and files structure in XCode and reflected similarly in project’s directory ✅  
Helper methods  ✅  
Custom Protocol ✅  
Singleton pattern  ✅  
Unit test  ✅  
Few Ui tests ✅   
Comments ✅  
Pragma marks ✅  
Constraints outlets ✅  
Cocoapods ✅   
blocks   ❌ // didn’t find a proper use for it.  
etc…   

     What could be done if given more time/data: 

- Sorting Routes By price , Distance , Least walking   
- Legends in legends’ view become clickable and thus the user could choose what transportation methods he/she’s looking for and see the available times     
- Find a better way to display SVG images more smoothly [Note: some images are empty - others show but  damage performance - I decided to comment some of them out  to better display the ViewControllers // you can observe what’s happening by uncommenting anything that contain SVGKImage(contentsOf …]   
- Add custom details page for certain routes (i.e taxi & car sharing has properties like taxi companies , address,  license plate , fuel engine etc….)
