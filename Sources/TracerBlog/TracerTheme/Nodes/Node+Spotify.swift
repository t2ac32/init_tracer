//
//  File.swift
//  
//
//  Created by Eduardo Prado Ruiz on 09/01/22.
//

import Foundation
import Plot
import Publish

struct embedSpotify:Component {
    var track_link: String
    
    var html_script: Node<Any> {
        return Node<Any>.raw("""
                <iframe src="\(track_link)?utm_source=generator&theme=0" width="100%" height="380" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"></iframe>
                """)
    }
    
    var body: Component {
        Node.group([html_script])
    }
}
