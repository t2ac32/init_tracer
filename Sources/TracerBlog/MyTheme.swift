//
//  File.swift
//  
//
//  Created by Eduardo Prado Ruiz on 27/11/21.
//

import Plot
import Publish
import Foundation
import CloudKit

public extension Theme {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var TracerTheme: Self {
        Theme(
            htmlFactory: FoundationHTMLFactory(),
            resourcePaths: ["Resources/TracerTheme/styles.css","Resources/TracerTheme/tracer_styles.css"]
        )
    }
}

private struct FoundationHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        
        HTML(
            .lang(context.site.language),
            .tracerHead(for: index, on: context.site),
            .body {
                MyHeader(context: context, selectedSelectionID: nil)
                Div{}.class("div-background")
                //SiteHeader(context: context, selectedSelectionID: nil)
                Grid {
                    Div {
                        TwitterTimeline()
                        //H1(index.title)
                        //Paragraph(context.site.description).class("description")
                    }.class("sidebar pure-u-1 pure-u-md-1-4")
                    Div {
                        TracerCard()
                        Div{
                            // Latest Content and articles
                            H2("Latest content")
                            ItemList(
                                items: context.allItems(
                                    sortedBy: \.date,
                                    order: .descending
                                ),
                                site: context.site
                            )
                        }.class("content pure-u-md-2-1").style("margin-right:100px;")
                        
                    }.class("content pure-u-1 pure-u-md-3-4")
                }
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .tracerHead(for: section, on: context.site),
            .body {
                MyHeader(context: context, selectedSelectionID: section.id)
                Div{}.class("div-background")
                Wrapper {
                    H1(section.title)
                    ItemList(items: section.items, site: context.site)
                }.class("content")
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .tracerHead(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    MyHeader(context: context, selectedSelectionID: item.sectionID)
                    Div{}.class("div-background")
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .tracerHead(for: page, on: context.site),
            .body {
                let projects = projects
                MyHeader(context: context, selectedSelectionID: nil)
                Div{}.class("div-background")
                
                
                if page.path == "projects" {
                    ProjectsIndex(items: projects.items, site: context.site)
                }else if page.path == "watchlist"{
                    AnimeWatchList().class("content")
                    //Wrapper(AnimeWatchList()).class("content")
                }else {
                    Wrapper(page.body)
                }
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .tracerHead(for: page, on: context.site),
            .body {
                MyHeader(context: context, selectedSelectionID: nil)
                Div{}.class("div-background")
                Wrapper {
                    H1("Browse all tags")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(tag.string,
                                 url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag")
                    }
                    .class("all-tags")
                }
                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .tracerHead(for: page, on: context.site),
            .body {
                MyHeader(context: context, selectedSelectionID: nil)
                Div{}.class("div-background")
                Wrapper {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

                    Link("Browse all tags",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?

    var body: Component {
        Header {
            Wrapper {
                Link(context.site.name, url: "/")
                    .class("site-name")

                if Site.SectionID.allCases.count > 1 {
                    navigation
                }
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]
                
                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }.class("pure-menu-list item-list")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}
struct ProjectsIndex<Site: Website>: Component {
    var items: [Project] = projects.items
    var site: Site
    
    var body: Component {
        Grid {
            Wrapper{
                Div{
                    //Project List
                    H2("Projects")
                    ProjectsList(items: items, site: site)
                }.style("padding:10px;")
            }.class("content pure-u-1")
        }
    }
}

struct ArticleIndex<Site: Website>: Component {
    var site: Site
    
    var body: Component {
        Wrapper{
            Div{
                //// Article Data
                // Header title
                H2("Projects")
                //ProjectsList(items: items, site: site)
            }.style("padding:10px;")
        }.class("content pure-u-1")
    }
}

private struct ProjectsList<Site:Website>: Component {
    var items: [Project]
    var site: Site

    var body: Component {
        List(items) { item in
            ProjectCell(project: item)
        }
        .class("pure-list").style("")
    }
}

private struct TracerCard: Component {
    var body: Component {
        // Presentation Card
        Wrapper {
            Image(url:"images/closeBW.jpeg", description: "").class("img-avatar")
            Div {}.class("blackLine")
            Div{
                Paragraph("今後: Machine Learning Engineer • 過去: iOS Developer").class("katakanaFont")
            }
        }.class("tracer-card").style("text-align: center;")
    }
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Paragraph {
                Text("Hello I'm Tracer!").style("margin-bottom: 8px;")
            }
            Paragraph {
                Link("Github", url: "https://github.com/t2ac32")
            }.style("margin-bottom: 32px;")
            Paragraph {
                Text("Generated using ")
                Link("Publish", url: "https://github.com/johnsundell/publish")
            }
            Paragraph {
                Link("RSS feed", url: "/feed.rss")
            }
        }.class("content")
    }
}
