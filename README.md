# Project 4 - *Instagramming-A*

**Instagramming-A** is a photo sharing app using Parse as its backend.

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [x] User gets access to a setting screen where they can change their profile picture, username and bio.
- [x] Comments display authors name and profile picture as well as the creation date, their profiles can be accessed trough their image.
- [x] User can like the post only once and the post can also be unliked. 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Different "tabs" within the same page using segmented control. 
2. Push notifications.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/MjtxpM3FUS.gif' title='Video Walkthrough 1' width='' alt='Video Walkthrough 1' />
<img src='http://g.recordit.co/rybfuAgO3I.gif' title='Video Walkthrough 1' width='' alt='Video Walkthrough 1' />

GIF created with [RecordIt](https://recordit.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse](http://parseplatform.org/Parse-SDK-iOS-OSX/api/) - database
- [DateTools](https://github.com/MatthewYork/DateTools) - date format library
- [ResponsiveLabel](hhttps://cocoapods.org/pods/ResponsiveLabel) - dynamic text within labels
- [MBProgressHUD](https://cocoapods.org/pods/MBProgressHUD) - loading indicator


## Notes

To actually create comments and likes as the ones in the real app I had to create another table or object for the parse database in which I stored the relation between the post at hand and the author of the comment or like. I actually did implement a custom camera view but the default one, offered by the phone, includes more functionalities and looks better. I would like to further customize the content of a collection view since, at the moment, it appears to me that it only works properly when containing solely an image. 

## License

    Copyright [2020] [Andres Barragan]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
