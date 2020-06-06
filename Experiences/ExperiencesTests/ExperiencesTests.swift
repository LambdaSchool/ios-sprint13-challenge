//
//  ExperiencesTests.swift
//  ExperiencesTests
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import XCTest
@testable import Experiences

class ExperiencesTests: XCTestCase {
    let videoExperience = VideoExperience(location: Location(latitude: 20, longitude: 20), title: "A Title")

    func testExperienceController() {
        let controller = ExperienceController.shared

        let storyExperience = Experience(
            lastEdit: nil,
            location: Location(latitude: 20, longitude: 20),
            title: "A title",
            body: nil,
            audioFile: nil)

        let id = storyExperience.id

        controller.append(storyExperience)

        var storyExperienceFromController = controller.getStoryExperience(with: id)
        XCTAssertNotNil(storyExperienceFromController)
        XCTAssertEqual(storyExperienceFromController?.id, id)
        XCTAssertEqual(controller.count, 1)


        let videoId = videoExperience.id

        controller.append(videoExperience)

        let videoExperienceFromController = controller.getVideoExperience(with: videoId)
        XCTAssertNotNil(videoExperienceFromController)
        XCTAssertEqual(videoExperienceFromController?.id, videoId)
        XCTAssertEqual(controller.count, 2)

        controller.remove(with: id)
        storyExperienceFromController = controller.getStoryExperience(with: id)
        XCTAssertNil(storyExperienceFromController)
        XCTAssertEqual(controller.count, 1)
    }

    func testExperienceControllerIsSingleton() {
        let controller1 = ExperienceController.shared
        let controller2 = ExperienceController.shared
        //let controller3 = ExperienceController() //inaccessible due to private - good

        XCTAssertEqual(controller1.count, controller2.count)
        controller1.append(videoExperience)
        XCTAssertEqual(controller1.count, controller2.count)
        controller2.remove(with: videoExperience.id)
        XCTAssertEqual(controller1.count, controller2.count)

    }

}
