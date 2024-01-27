<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

## About The Project

| Main Screen | Location Screen | Search Screen | Preview Weather Screen |
| --- | --- | --- | --- |
| <img src="Images/MainScreen.png" alt="Main screen"> | <img src="Images/LocationsScreen.png" alt="Location Screen"> | <img src="Images/SearchScreen.png" alt="Search Screen"> | <img src="Images/PreviewWeatherScreen.png" alt="Preview Weather Screen"> |

<br>
<p>An iOS app that visually clones Spotify's app and consumes the official Spotify's Web API to show(and play) songs, artists and more. It was made as final project for IT-Academy iOS course.

Due to some limitations from Spotify WEB API, this app can play only 30 seconds of song. Some songs don't even have such preview, so I had to remove them.

Instead of using Spotify user playlist feature, I saved playlists to local database using Realm.
</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Built With

<p>This app was build using MVVM-C architecture. Frameworks were integrated with Swift Package Manger. I've used Observer and Delegate paterns.</p>
<br>
<ul>
    <li>Keychain</li>
    <li>UIKit</li>
    <li>AVFoundation</li>
    <li>Alamofire</li>
    <li>Realm</li>
    <li>SDWebImage</li>
    <li>Caching</li>
    <li>Dependency Injection</li>
    <li>XCode Instruments</li>
</ul>

<p>Alamofire was used for getting and parsing data from Spotify WEB API, Realm for storing user playlists locally. SDWebImage was used for geting images by passing url to it and cache images for later use.
Cached images were used for generating average color and then passing it to generate gradient for background</p>

## Contact
My [LinkedIn](https://www.linkedin.com/in/nicktsaruk/)
