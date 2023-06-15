# Jawhara Project

A Jawhara project created in flutter using Stacked and Provider. Jawhara supports mobile only

* For Mobile: https://gitlab.com/mahmed5/jawhara/-/tree/dev (Develop channel)

## Getting Started

The Jawhara contains the minimal implementation required to create a new library or project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new
project. By using jawhara plate code as standard initializer, we can have same patterns in all the projects that will inherit it. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing
from scratch.

## How to Use

**Step 1:**

Download or clone this repo by using the link below:

```
https://gitlab.com/mahmed5/jawhara.git
```

**Step 2:**

Go to project root and execute the following command in a console to get the required dependencies:

```
flutter pub get 
```

## Jawhara Features:

* Auth
    * Login / Sign up / Forget password
    * Facebook login & Google Login
* Home
* Categories, sub categories & sub-sub categories
* Products
* Product details
* Shop cart
* Wish list
* Shipping Address
* Billing Address
* Check out
* Search product
* Orders
* Payment online methods
* Gift card
* Point reward
* Return product
* Contact us

### Up-Coming Features:


* Profile edit
* Terms page

### Libraries & Tools Used

* [Dio](https://pub.dev/packages/dio)
* [Dio Http Cache](https://pub.dev/packages/dio_http_cache)
* [Stacked](https://pub.dev/packages/stacked) (Mvvm Architecture)
* [Provider](https://pub.dev/packages/provider) (State Management)
* [Get It](https://pub.dev/packages/get_it) (Service Locator)
* [Shared preferences](https://pub.dev/packages/get_it) (Storage)
* [Flutter Translate](https://pub.dev/packages/flutter_translate) (MultiLang)
* [Flutter widget from html core](https://pub.dev/packages/flutter_widget_from_html_core) (Web Html Widget)
* [Page Transition](https://pub.dev/packages/page_transition) (Navigate between screens with animation)

### Folder Structure

Here is the core folder structure which flutter provides.

```
jawhara/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- core/
  |- api/
  |- config/ 
  |- constants/  
|- model/
|- view/
  |- ui/
  |- widgets/  
|- viewModel/
|- main.dart
|- app.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- main.dart - This is the starting point of the application. All the application level configurations are defined in this file orientation, Status bar, Translate localizations.
2- app.dart - This is the second point of the application. Which detect go to login or home page, Init BotToast, Init Translate, 
3- core - Contains the data layer of your project, includes directories for api, config and constants.
4- core/config - Contain handlin error exception, locator, shared data, translate, validation.
5- core/constants - All the application level constants are defined in this directory with-in their files. This directory contains the constants for app_theme, colors, dimens, font_family, icomoon, strings
6- model - Contains retrieve of your application, to connect the data of your application with the UI. 
7- ui — Contains all the ui of your project, contains sub directory for each screen.
8- widgets — Contains the common widgets for your applications. For example, Loading, Buttons etc.
9- viewModel - Contains all the method or function which responsible betweem your UI and retrieve data in model 
```

### Retrieve data (Model)

This directory contains all the model, you can create automatic from a generator of model like 
* [Quick Type](https://app.quicktype.io/) (Help in generate automatic model to dart )

A separate file is created for each type as shown in example below:
```
model/
|- cart
|- categories
|- orders
|- product
```


### ViewModel (Methods)

This directory contains all method, you can create from template ready you will find it in
```
viewmModel/
|- new_view_model.dart
```

### Developing environment:
```
Developed with Flutter on Dev Branch (Flutter 1.22.5 • channel stable • https://github.com/flutter/flutter.git).
Dart SDK Dev Branch (2.10.4).
```

### Release Certificates Fingerprints:
```
MD5: (##Missing).
SHA1: (##Missing).
SHA256: (##Missing).
```
### Application runs on:
```
Android SDK version: (30.0.2).
Xcode: (12.3).
```

### Developers worked on this:
* [Muhmmed Abd-Elkhalik](https://github.com/muhmmedAbdelkhalik)
