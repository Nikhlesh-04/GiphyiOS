
# Giphy 

Contacts app for iOS platform using SwiftUI.

Architecture :- MVVM  
IDE :- Xcode 13.4.1  
Language :- Swift 5, SwiftUI
Design :- Giphy trending & Search gif's view as listing and grid  

# Functionality

The application performs very simple functionality of showing trending giphy gif and search giphy gif with giphy api's.

There are two tabs in a application.

First Tab: Contains a search bar for search gif's from giphy search api. By default first tab showing treanding giphy gif's from giphy trending api.
  User can mark gif favorite and unfavorite so all favorite gifs store locally in a device file manager.

Second Tab: Contains a segment bar on top to switch the view between grid and list. By default the grid is selected.
  Contains a collection view that displays GIFs after fetching them from the file storage.
  User should be able to unlike any GIFs by pressing the favorite button.
  Fetch GIFs from the file storage that were made favorite in the First tab.

This application have adopt dynamic device mode as light/dark mode with dynamic font size as device.

In this app we also add unit test cases and UI test cases.
