# Experiences

## Instructions

**Please read this entire README to make sure you understand what is expected of you before you begin.**

This sprint challenge is designed to ensure that you are competent with the concepts taught throughout Sprint 13, Media Programming.

Begin by forking this repository. Clone your forked repository to your machine. There is no starter project. Create a project for this challenge in this repository and commit as appropriate while you work. Push your final project to GitHub, then create a pull request back to this original repository.

**You will have 3 hours to complete this sprint challenge**

If you have any questions about the project requirements or expectations, ask your PM or instructor. Good luck!

## Screen Recording

**The screen recording is a video file included in the repo. Watch it to know how the project should function**

## Requirements

The goal of this sprint challenge is to create an app that helps the user create an "experience".

The requirements for this project are as follows:

1. A single model object that represents an experience. The requirements for this model object are:
      - An audio recording
      - A video recording
      - An image
      - The model object must and conform to the `MKAnnotation` protocol. 

**Note:** You are welcome to add any other properties and methods you wish in the model object.

2. A map view controller that adds an annotation for each experience created. Simply show the title of the experience on the annotation.
3. A straightforward UI similar to the screen recording that lets a user create an experience with an image, video, audio, and location. The location can either be the user's current location or you may let them select a location however you choose to implement it (`MKLocalSearch`, pin dropping, etc).
4. The image must be filtered in some way. In the screen recording example, it desaturates the image after the user picks an image from their photo library.

## Go Further

* Add a custom callout view to the annotations that shows either the image, video, a way to play the experience's audio, or a combination of the three.
* Persist the experiences using Core Data or Firebase (either using the SDK or just as a REST API).
