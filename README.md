InitialsImageView
===================

An easy, helpful UIImageView extension that generates letter initials as a placeholder for user profile images, with a randomized background color

![Example screenshot](https://i.imgur.com/KE8OfrL.png)

### Installation

##### CocoaPods

Add this spec to your podfile:

`pod "InitialsImageView"`

Check out the [official guide](http://guides.cocoapods.org/using/index.html) for getting started with CocoaPods.

##### Manual

1. Drag the `InitialsImageView.swift` file into your project
2. Enjoy!

### Usage

##### Methods

Call the following methods on any `UIImageView` instance to set the image:

+ `setImageForName(string: String, backgroundColor: UIColor?, circular: Bool, textAttributes: [String: AnyObject]?)`

`string` is the string used to generate the initials. This should be a user's full name if available.

`backgroundColor` is an optional parameter that sets the background color of the image. Pass in `nil` to have a color automatically generated for you.

`circular` is a boolean parameter that will automatically clip the image to a circle if enabled.

`textAttributes` is an optional dictionary of predefined character attributes for text. You can find the list of available keys in NSAttributedString

##### Example

```
let randomImage: UIImageView = UIImageView.init(frame: CGRect(x: self.view.bounds.midX - 40, y: self.view.bounds.midY - 80 - 40, width: 80, height: 80))
randomImage.setImageForName(string: "Michael Bluth", backgroundColor: nil, circular: true, textAttributes: nil)
```

### Saying Thanks

If you like this tool, show your support by downloading the free [Turnout](https://itunes.apple.com/us/app/turnout-make-plans-w-friends/id1393733205?mt=8) app that inspired it!

### License

Using the MIT license. See license file for details.
