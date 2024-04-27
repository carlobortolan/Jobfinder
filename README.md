# Jobfinder App

> [!IMPORTANT]
> As of April 27, 2024, this project has been archived and will probably not be activated or updated in the future.

This repository contains the source code for a simple jobfinder mobile app written before the start of the TUM iPraktikum W23/24.
The app is a iOS >= 14.0 application built with SwiftUI that serves as a mobile client to a deprecated version of [Embloy's API](httpt://github.com/embloy/). It allows users to search for jobs, apply filters, and view job details.

## Demo

https://github.com/carlobortolan/Jobfinder/assets/106114526/913f8a9e-c184-4ef5-969d-4c8d4d7c913c

## License

### Licensed under

> GNU AFFERO GENERAL PUBLIC LICENSE v3.0 ([gpl-3](https://www.gnu.org/licenses/gpl-3.0.en.html))

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by anyone, as
defined in the GNU AFFERO GENERAL PUBLIC LICENSE v3.0 license, shall be licensed as above, without any additional terms
or conditions.

## Key Features

- **Job Feed:** Users can scroll an instagram-like feed with jobs that match the user's preferences.

- **Job Search:** Users can search for jobs based on keywords, location, job type, and sorting preferences.

- **Filter and Sort:** Users can filter job search results by job category and sort them by relevance, salary, or date.

- **Job Details:** Users can view detailed information about a job, including the job title, description, location, salary, and more.

- **User Authentication:** The app supports user authentication, allowing users to log in and access personalized features.

## Prerequisites

Before running the app, ensure you have the following:

- Xcode: The app is developed using Xcode, so make sure you have it installed on your macOS.

- Swift and SwiftUI Knowledge: Familiarity with Swift programming language and SwiftUI framework is recommended to understand and extend the app. Some classes (e.g. APIHandlers in [/networking](/mobile/Networking)) already contain detailed method documentation.

## Getting Started

1. **Clone the Repository:** Clone this repository to your local machine using `git clone`.

2. **Open the Project:** Open the project in Xcode by double-clicking the `.xcodeproj` file.

3. **Run the App:** Build and run the app on a simulator or a physical device using Xcode or run `swift build`.

4. **Explore the App:** Once the app is running, you can explore its features, including job search, filtering, sorting, and job details.

## Customization

You can customize the app by making changes to the code. Here are some areas you might want to customize:

- **API Integration:** The app makes API requests to fetch job data. You can update the API endpoints and data models to work with your local [Embloy-Backend](https://github.com/embloy/embloy-backend).

- **Styling:** Customize the app's appearance by modifying the SwiftUI views' styles, colors, and layouts.

- **Authentication:** The app includes user authentication. You can integrate your own authentication system or backend services.

- **Job Categories and Sorting Options:** You can update the available job categories and sorting options in the `FilterAndSortView` by modifying the `jobCategories` and `sortingOptions` arrays.

## Compatibility

The app is designed to work on iOS devices running iOS 14 and later. It adapts to various screen sizes and orientations, providing a responsive user experience.

## Acknowledgments

- [SwiftUI](https://developer.apple.com/xcode/swiftui/): The app is built using SwiftUI, Apple's modern declarative UI framework.

- [Xcode](https://developer.apple.com/xcode/): The development environment used to build and run the app.

- [URLImage 3.1.1](https://github.com/dmytro-anokhin/url-image/):  AsyncImage before iOS 15. Lightweight, pure SwiftUI Image view, that displays an image downloaded from URL, with auxiliary views and local cache. 

---

© Carlo Bortolan

> Carlo Bortolan &nbsp;&middot;&nbsp;
> GitHub [carlobortolan](https://github.com/carlobortolan) &nbsp;&middot;&nbsp;
> contact via [carlobortolan@gmail.com](carlobortolan@gmail.com)
