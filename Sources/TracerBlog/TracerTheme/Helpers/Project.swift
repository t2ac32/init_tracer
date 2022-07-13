//
//  Project.swift
//
//
//  Created by Mihai Leonte on 20/01/2020.
//
import Foundation
import Publish
import Plot
import Publish


enum ProjectType {
    case general
    case song
    case playlist
    case publication
}
struct Project {
    
    let name: String
    let project_type: ProjectType
    let code: String
    let subheader: String // The header under the app's name
    let status: String // In Progress or Published
    let status_css: String // Class name for the CSS style to be applied to the status
    let appIcon: String // Filename of the app's icon
    let videoFile: String
    let role: String // My Role
    let link: String //Online link to hosted project
    let linked_file: String?
    let gitHub_link: String
    let technologies: [String]
    let paragraphs: [String] // Description
    
}

/**
    # Projects
    Hleper struct that holds an array of  "project" objects representing active or done the projects.
    - Parameter items: Array of struct *Project* objects.

 */

struct Projects {
    let items: [Project]
}

/**
    # projects
    Constant holding a list *Projects* to be rendered by makePageHTML.
    - Parameter items: Array of struct *Project* objects.

 */

let projects = Projects(items: [
    .init(name: "PSNR-HVS-M-for-python",
          project_type: ProjectType.general,
          code: "Peak Signal to noise ration",
          subheader: "PSNR-HVS-M",
          status: "Released",
          status_css: "release",
          appIcon: "/images/projects/PATTERNS.png",
          videoFile: "",
          role: "Developer",
          link:"",
          linked_file: "/Publications/DL_HDR_US_2019.pdf",
          gitHub_link: "https://github.com/t2ac32/PSNR-HVS-M-for-python/",
          technologies: ["python","image analysis","imaging"],
          paragraphs: ["A python implementation of PSNR that takes the Human visual system into account. This code is based on Nikolay Ponomarenko matlab implementation of the PSNR-HVS & PSNR-m algorithm."]),
    
    .init(name: "Deep-Learning High-Dynamic-Range Ultrasound",
          project_type: ProjectType.publication,
          code: "DL-HDR ultrasound",
          subheader: "Deep Learning HDR Ultrasound",
          status: "published",
          status_css: "published",
          appIcon: "/images/projects/hdr_us.png",
          videoFile: "",
          role: "Sole developer",
          link:"https://ieeexplore.ieee.org/document/8925685",
          linked_file: "/Publications/PAVLOV_2019.pdf",
          gitHub_link: "https://github.com/t2ac32/master-thesis-usHDR",
          technologies: ["Python", "Polyaxon", "DeepLearning", "Pandas", "Pytorch","Machine Learning"],
          paragraphs: ["In this paper, we asses the use of a deep learning neural networks on predicting HDR values from low dynamic range (LDR) input images. We demonstrated that this type of networks can be trained to predict HDR out from a minimal number of input expositions."]),
    
    .init(name: "Towards in-vivo ultrasound-histology:",
          project_type: ProjectType.publication,
          code: "",
          subheader: "GANS for pixel-wise Ultrasound Reconstruction",
          status: "published",
          status_css: "published",
          appIcon: "/images/projects/pavlov.png",
          videoFile: "",
          role: "Collaborator developer",
          link:"https://ieeexplore.ieee.org/document/8925722",
          linked_file: "",
          gitHub_link: "",
          technologies: ["matlab", "DeepLearning", "Pandas", "Pytorch","Machine Learning","GAN's"],
          paragraphs: ["Ultrasound imaging is a well-established modality, widely used for in vivo real time examination. Deep-learning-based methods carry a possibility to overcome Ultrasound limitation and enable robust signal-based tissue identification"]),
    
    .init(name: "Koikite",
          project_type: ProjectType.song,
          code: "Koi kite",
          subheader: "Koikite feature on POAT records compilation",
          status: "Released",
          status_css: "release",
          appIcon: "",
          videoFile: "",
          role: "Producer/Composer",
          link:"https://open.spotify.com/embed/track/2e9ZjR29YGIF1d4dGsZWob",
          linked_file: "",
          gitHub_link: "",
          technologies: ["Ableton", "Music", "POAT", "electronic", "lo fi", "Mexico"],
          paragraphs: ["Heavily inspired by The legend of zelda: Breath of the wild, this song explores simple ambients, playful velocity on the snares and rain sounds of the outskirts of Guadalajara, Mexico."]),
    
    .init(name: "Neon WaterCourse",
          project_type: ProjectType.song,
          code: "net_worthy",
          subheader: "Neon Water course EP",
          status: "Released",
          status_css: "release",
          appIcon: "",
          videoFile: "",
          role: "Producer/Composer",
          link:"https://open.spotify.com/embed/track/7Bl8lJVbN9iugq2nriqsc4",
          linked_file: "",
          gitHub_link: "",
          technologies: ["Ableton", "Music", "Ep", "POAT", "electronic", "lo fi", "home", "glitch", "vaporwave", "Mexico"],
          paragraphs: ["First release EP an exploration into electronic music, sampling and synth production. Neon water course tells a story of lo-fi, glitch and Neon light on a not so distant future."])
])


struct ProjectCell:Component {
    var project: Project
    
    var body: Component {
        // Project info cell with image
        Div {
            Div {
                ProjectIcon(project: project)
            }.class("pure-u-1-2 project-image")
            Div{
                Article {
                    H1(Link(project.name, url: ""))
                    TechnologiesTagList(items: project.technologies)
                    H2(project.subheader)
                    Text(project.paragraphs[0]).style("text-align: justified")
                }
            }.class("pure-u-1-2 ")
        }.class("pure-g project-cell").style("text-align: center;")
    }
}

struct ProjectIcon:Component {
    var project: Project
    //var type: ProjectType
    //var link: String
    
    var body: Component {
        if project.project_type == ProjectType.song {
            return embedSpotify(track_link: project.link)
        } else if project.project_type == ProjectType.playlist {
           return embedSpotify(track_link: project.link)
        } else {
            //return project image
            return Image(url: project.appIcon, description: "").class("project-image")
        }
    }
}

struct TechnologiesTagList: Component {
    var items:[String]

    var body: Component {
        List(items) { tech in
            Text(tech)
        }
        .class("tag-list")
    }
}
/**
 Article {
     H1(Link(item.title, url: item.path.absoluteString))
     ItemTagList(item: item, site: site)
     Paragraph(item.description)
 }
 */
