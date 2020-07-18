# Experiences

## Instructions

**Please read this entire README to make sure you understand what is expected of you before you begin.**

This sprint challenge is designed to ensure that you are competent with the concepts taught throughout Media Programming.

Begin by forking this repository. Clone your forked repository to your machine. There is no starter project. Create a project for this challenge in this repository and commit as appropriate while you work. Push your final project to GitHub, then create a pull request back to this original repository.

**You will have 3 hours to complete this sprint challenge**

If you have any questions about the project requirements or expectations, ask your TL or instructor. Good luck!

## Screen Recording

**The screen recording is a video file included in the repo. Watch it to know how the project should function.**

## Requirements

The goal of this sprint challenge is to create an app that helps the user create an "experience" over time. The user should be able to see where these experiences happened on a map.

The requirements for this project are as follows:

1. At least one model object that represents an experience. You must be able to create experiences that can include:
      - Title and/or description
      - An image
      - An audio recording
      - Stretch (optional): A video recording
2. Not every experience will use all types of media, you decide on the best way to create an experience. Evernote has a special `+` button for adding photos, videos, and audio recordings to documents.
3. The experience must be geotagged so that the user can see on a map where the experience happened.
      1. One experience model object must conform to the `MKAnnotation` protocol. 
      2. A map view controller that adds an annotation for each experience created. Simply show the title of the experience on the annotation.
      3. The location can either be the user's current location or you may let them select a location however you choose to implement it (`MKLocalSearch`, pin dropping, etc).
4. You are welcome to add any other properties and methods you wish in the model object.
5. MVP UI can be similar to the screen recording (Experiences Screen Recording.MP4) that lets a user create an experience with an image, video, audio, and location. 
6. Use the inspiration below for guidance on a UI design that is already tested and easy to use.
7. The image must be filtered in some way. In the screen recording example, it desaturates the image after the user picks an image from their photo library. 
      1. You can add a image edit button to allow the user to use different photo filters.

## Inspiration

* [Day One](https://dayoneapp.com) - multimedia-rich journaling app
* [Momento App](https://momentoapp.com) - journaling app
* [Evernote](https://apps.apple.com/us/app/evernote/id281796108)
* Look at Apple's Notes to see how media can be added to a note
* [Instagram](https://apps.apple.com/us/app/instagram/id389801252)'s photo editor

## Go Further
* Add in video capture and playback
* Add a custom callout view to the annotations that shows either the image, video, a way to play the experience's audio, or a combination of the three.
* Persist the experiences using Core Data or Firebase (either using the SDK or just as a REST API).
* Add an image editor screen to choose between 3-5 different editing tools.
 
