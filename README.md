# Experiences

## Instructions

**Read these instructions carefully. Understand exactly what is expected _before_ starting this Sprint Challenge.**

This sprint challenge is designed to ensure that you are competent with the concepts taught throughout Media Programming.

This challenge allows you to practice the concepts and techniques learned over the past sprint and apply them in a concrete project. This sprint explored **Media Programming**. During this sprint, you studied **Core Image**, **Audio**, **Video**, and **MapKit**. 

In your challenge this week, you will demonstrate your mastery of these skills by creating **an app to create geographic experiences using images, audio recordings, videos, and location.**.

This is an individual assessment. All work must be your own. Your challenge score is a measure of your ability to work independently using the material covered through this sprint. You need to demonstrate proficiency in the concepts and objectives introduced and practiced in preceding days.

You are not allowed to collaborate during the sprint challenge. However, you are encouraged to follow the twenty-minute rule and seek support from your TL if you need direction. 

_You have **three hours** to complete this challenge. Plan your time accordingly._

## Introduction

**Watch the screen recording video file (included in the repository)** to know how the app should function.

### Commits

Commit your code regularly and meaningfully. This helps both you (in case you ever need to return to old code for any number of reasons) and your team lead as the evaluate your solution.

## Interview Questions

Be prepared to demonstrate your understanding of this week's concepts by answering questions on the following topics. You might prepare by writing down your own answers before hand.

1. Describe what Core Image filters can do.

2. Understand how to create a CIFilter using an image and the filter attributes (any filter except CIColorControls).

3. Explain how to load a file from the app bundle.

4. Explain how to create a unique file path in the Documents directory.

5. Explain how to get permission for the microphone or camera, and what happens when the user denies the request. 

6. Describe how to set up a AVCaptureSession for video playback and recording.

7. Describe how to make a model object visible as an annotation on a MKMapView

You are expected to be able to answer questions in these areas. Your responses contribute to your Sprint Challenge grade. 

## Instructions

### Task 1: Project Set Up

- [ ] Fork this project
- [ ] Add your team lead (TL) as collaborator on Github
- [ ] Clone your OWN version of the repository (Not Lambda's by mistake!)
- [ ] Create a new branch: `git checkout -b <firstName-lastName>` (Use your name without brackets: Emily-Smith)
- [ ] Implement the project on your newly created `<firstName-lastName>` branch and commit changes regularly
- [ ] Push commits: `git push -u origin <firstName-lastName>`

## Task 2: Project Requirements

The goal of this sprint challenge is to create an app that helps the user create an "experience" over time. The user should be able to see where these experiences happened on a map.

The requirements for this project are as follows:

1. At least one model object that represents an experience. You must be able to create experiences that can include:
      - An audio recording
      - A video recording
      - An image
      - Title and/or description
2. Not every experience needs to use all types of media — you can decide on the best way to create an experience. 
	1. Evernote has a `+` button for adding photos, videos, and audio recordings to documents. 
3. The experience must be geotagged so that the user can see where the experience happened on a map.
      1. One experience model object must conform to the `MKAnnotation` protocol. 
      2. A map view controller that adds an annotation for each experience created. Simply show the title of the experience on the annotation.
      3. The location can either be the user's current location or you may let them select a location (`MKLocalSearch`, pin dropping, etc).
4. You are welcome to add any other properties and methods you wish in the model object.
5. MVP UI can be similar to the screen recording (Experiences Screen Recording.MP4) that lets a user create an experience with an image, video, audio, and location. 
6. Use the inspiration below for ideas for UI design.
7. The image must be filtered in some way. 
	1. In the screen recording example, it desaturates the image after the user picks an image from their photo library. 
      2. You can add an "Edit" button to allow the user to use different photo filters.

## Inspiration

* [Day One](https://dayoneapp.com) - multimedia-rich journaling app
* [Momento App](https://momentoapp.com) - journaling app
* [Evernote](https://apps.apple.com/us/app/evernote/id281796108)
* Look at Apple's Notes to see how media can be added to a note
* [Instagram](https://apps.apple.com/us/app/instagram/id389801252)'s photo editor

## Go Further

* Add a custom callout view to the annotations that shows either the image, video, a way to play the experience's audio, or a combination of the three.
* Persist the experiences using Core Data or Firebase (either using the SDK or just as a REST API).
* Add an image editor screen to choose between 3-5 different editing tools.
* Add a button to toggle between a map view of the experiences and a table view.
	* Sort by date created with the most recent at the top of the table view
