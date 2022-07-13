import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct TracerBlog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case blog
        case CV
        case Showcase
        case Watchlist
        case Projects
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://t2ac32.github.io/init_tracer/")!
    var name = "[init] Tracer"
    var description = "A.I, VR, Mobile Dev, Electronics"
    var language: Language { .english }
    var imagePath: Path? { "/Resources/images" }
}

// This will generate your website using the built-in Foundation theme:
try TracerBlog().publish(
    withTheme: .TracerTheme,
    deployedUsing: .gitHub("t2ac32/t2ac32.github.io",branch: "master"),
    plugins: [
        .splash(withClassPrefix: ""),
    ]
)


