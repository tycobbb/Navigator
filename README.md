Navigator
=========

Navigator is a URL router for managing application state in iOS applications. Unlike existing solutions to this
problem that provide transitions using `key/:id -> view` mappings, Navigator diffs URLs into a sequence of updates
that generate the entire view stack and can perform any necessary animations. This provides for increased view controller
and animation modularity, and it eases the burden of implementing features like deep-linking or state-based analytics.

## Installation
You can install Navigator with [CocoaPods](http://cocoapods.org/).
```ruby
pod 'Navigator', '~> 0.5'
```
