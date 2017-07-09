# Final Project - Josh and Tyler

Our final project is entitled "Dropr" and is a maps-based application. The user can drop pins or "Dots" at their current location that other users can see, and each Dot contains its own title, description, and picture.

# We incorporated the following features:

- GPS / Location awareness: Our app uses Apple Maps and shows the user's current location and their surrounding pins. Users are able to drop pins ("Dots") at their current location that contain information (title, description, image). 
- Camera: Users can take a picture, or select one from their image library, and attach it to their Dot.
- Build and Consume your own web service: We built a RESTful Flask interface with an accompanying PostgreSQL database hosted on Heroku to store and serve all user submitted Dots.
- Consume a pre-built web service: We used Imgur's API to upload the users' images to their site and then download the images to their corresponding Dot for display.
- Data Storage using Key/Value pairs - UserDefaults: We used UserDefaults to store a unique Device ID so users can only delete Dots that were dropped from their specific device.

# Usage Requirements
- The only requirement is that when adding and deleting a Dot, you must refresh the MapView using the refresh button and move the map a little. Otherwise, it's pretty straight forward!
