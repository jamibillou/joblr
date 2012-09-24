# char_counter

The name speaks for itself, char_counter is a tiny helper made to add character counters to your textareas so users know how many characters are allowed.


## Installation

```ruby
gem 'char_counter', :git => 'https://github.com/dmatheron/char_counter.git'
```


## What it does and doesn't

It can only be used by passing a ruby class and attribute as arguments, the maximum is based on the attribute's length validation.

* It doesn't take minimum length into consideration.
* It cannot be used without an object and attribute.
* It is only customizable via a class passed in the options hash.

A danger-text CSS class will be added automatically when the maximum number of characters is reached.
This works nicely with Twitter boostrap for example, else you can make your own or ignore this feature.


## Requirements

You need jquery-rails and coffee-rails gems to use char_counter.


## Installation

In your application's javascripts, at the bottom of application.js, add:

```javascript
//= require char_counter
```

## Usage

In your views, add a counter by calling the char_counter_for helper next to your textareas:

```erb
<%= char_counter_for(Class, attribute) %>
```

Your can style your counter by passing a CSS class in the options hash:

```erb
<%= char_counter_for(Class, attribute, :class => 'your_css_class') %>
```

Make sure that your textarea and counter are in the same parent HTML tag and that they are no wrapped into any toher tag such as span, p, div, etc. **It will not work if you ignore this.**


## Testing

No test included at the moment, cucumber features will be added in the future.


## Roadmap

Nothing planned, we will make char_counter more flexible and useful if we need it.


## Contribute

Fork the project if you want to help, that's always welcome!


## Authors

Dominic Matheron and Franck Sabattier, [Joblr](http://joblr.co)
