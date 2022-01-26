
# SwiftUI: Basic app structure

## Project Navigator Structure

Inside Xcode we should see the following file in the space on the left (Project Navigator):
- **AppName.swift:** contains code for launching your app. If you create something when the app launches and keep it alive the entire time, you'll put it here
- **contentView.swift** contains the initial user interface (UI) for the program, and is  where we'll be doing all the work in this project.
- **assets.xcassets** the asset catalog, a collection of pictures that you want to use in your app. You can also add colors here, along with app icons. iMessage stickers, and more.
- **Preview Content** is a group , with Preview Assets.xcassets inside - tihs is another ssset catalog, this time specifically for example images you want to use when your're designing your user interfaces, to give you an idea of how they might look when the program is running.

## Important First steps
- **import SwiftUI:** imports the SwiftUI framework
- **struct ContentView:** View new struct called ContentView, conforming to View protocol.
    - The **'View'** comes from SwiftUI, and is the protocol that must be adopted by anything you wnat to draw on the screen. (text, buttons, images)
- **var body:** some View, the type 'some View' means something conforming to the View protocol will be returned (our layout)

### The view protocol
This protocol has only one requirement: to have a computed property called  body that returns 'some View'

### Modifiers
**padding()** method called on the text view, is and example of modifiers, which are regular methods with one small difference...     

		 They always return a new view that contains both
		 your original data, plus the extra
		 modification you asked for.  

## The Canvas
Automatically preview using one specific Apple device.
To change, look at the top center of your Xcode window for the current device, then click on it and select an alternative. This will also affect how your code is run in the virtual iOS simulator later on.

### Resume Automatic preview:
``` Option + Cmd + P``` - Resume automatic preview.

## Creating a form
Forms are scroling lists of static controls like text and images, but can also include user interactive controls like text fields, toggle switches, buttons and more.

To create a basic form:
```
var body: some View {
    Form {
        Text("Hello, Tracer!").padding()
}
```

*Limitations:* SwiftUI only allows 10 items to be added to a form. This limit applies to all childen inside a paren in SwiftUI.

## Groups
To add more than 10 children to a form we can use *Group* structs.
This doesn't change the look but works around the 10 children limitation.

## Sections
This applies a change of look to forms by splitting the items into chunks or sections. Sections split forms into discrete visual groups just like the settings app does:
```
Form {
    Section {
        Text("Hello, world!")
    }

    Section {
        Text("Hello, world!")
        Text("Hello, world!")
    }
}
```

# **Navigation:** NavigationView and bars

## Adding navigation bars
```
 var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello, Tracer!")
                }

                Section {
                    Text("This is section 2.")
                    Text("Hello, world!")
                }
            }.navigationTitle("test bar")
        }.navigationBarTitle("Navbar title").navigationBarTitleDisplayMode(.inline)

    }
```

# Modifying program state
SwiftUI’s views are a function of their state, we mean that the way your user interface looks – the things people can see and what they can interact with – are determined by the state of your program.

```
struct ContentView: View {
    var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}
```

ContentView is a struct, structs are *immutable , the code above will give us an mutability error.

## *property wrapper*
Property wrappers are special attributes we can place before our properties that effectively gives them super-powers.

## @State wrapper
**@State** allows us to work around the limitation of structs: we know we can’t change their properties because structs are fixed, but @State allows that value to be stored separately by SwiftUI in a place that can be modified.

```
struct ContentView: View {
    @State var tapCount = 0

    var body: some View {
        Button("Tap Count: \(tapCount)") {
            self.tapCount += 1
        }
    }
}
```
***Tip:*  @State is specifically designed for simple properties that are stored in one view. As a result, Apple recommends we add private access control to those properties, like this:    

```
      @State private var tapCount = 0.
```

## Binding state to UI controls

The problem is that Swift differentiates between “show the value of this property here” and “show the value of this property here, but write any changes back to the property.”

## *two-way binding*
We bind the text field so that it shows the value of our property, but we also bind it so that any changes to the UI CONTROL also update the property.

In Swift, we mark these two-way bindings with a special symbol so they stand out: we write a *dollar sign* before them.

```
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        Form {
            TextField("Enter your name", text: $name)
            Text("Hello, world!")
        }
    }
}
```

## Views in a loop
### The forEach view:
This SwfitUI view can loop over arrays and ranges, creating as many views as needed. Even better, this view doesn't get git by the 10-view limit.

ForEeach runs a closure once for every item it loops over, passing in the current loop item.

For example, this creates a form with 100 rows:
```
  Form {
      ForEach(0..<100) { number in
          Text("Row \(number)")
      }
  }

  shorthanded version since ForEach passes a closure
  Form {
      ForEach(0..<100) { number in
          Text("Row \($0)")
      }
  }

```
### Use case
ForEach is particularly useful when working with SwiftUI’s Picker view,
Example define a view that:

1. Has an array of possible student names.
2. Has an @State property storing the currently selected student.
3. Creates a Picker view asking users to select their favorite, using a two-way binding to the @State property.
4. Uses ForEach to loop over all possible student names, turning them into a text view.

```
struct ContentView: View {
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"

    var body: some View {
        NavigationView {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}
```
- **note:**  *id: \.self* part is important. This exists because SwiftUI needs to be able to identify every view on the screen uniquely, so it can detect when things change. 
