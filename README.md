# Slick - A minimal exponential easing library for AwesomeWM

Slick is an easing library that allows you to easily incorporate animations into your AwesomeWM configuration.

## Installation

Clone this repository somewhere AwesomeWM can see it. For example,
```sh
cd ~/.config/awesome
git clone https://github.com/polluxprograms/slick.git
```

## Usage

Import the library where needed
```lua
local slick = require('slick')
```

Create an animation wrapper for each parameter to be animated
```lua
local animation = slick(0, {
    refresh_rate = 144,
    speed = 20,
    stop = function(value, target)
        return (math.abs(value - target) < 0.2)
    end
    callback = function(value)
        ...
    end
})
```

This constructor takes the initial value the parameter should be set to, and a table of options.

The following animation options are available:
- refresh_rate: How many times per second should the animation refresh, should
  ideally equal the refresh rate of your monitor. Default: 144
- speed: How fast should the animation be. Default: 20
- stop: A function that returns true when the animation should stop. Default: Shown in example above.
- callback: A function that sets the parameter being animated to the value it receives. No default, must be set.

To trigger the animation, simply call the `set` method of the animation table
and give the desired final value.
```lua
animation:set(10)
```


## A Note About Exponential Easing

Slick was designed to use only exponential easing due to how simple it is.
Exponential easing in one of the only kinds of stateless easing, where the
program only needs to know where the parameter is now and where it should be in
order to calculate the next position. This allows the target value to be
changed mid-animation while still looking smooth.

Exponential easing does have a strange quirk that makes it different from other
kinds of easing. Exponential easing technically never fully completes. The
animation will converge to the target, but will never actually reach it. This
is why Slick does not accept a duration for an animation. It is instead
replaced by a speed option, which controls how quickly the animation converges
on the target.

This is also why Slick needs a stop function to tell when it is done. Otherwise
the animation will continue forever, wasting computing power on imperceptible
changes in the parameter. The stop function will be called before each update,
and if true, the animation will be stopped and the parameter set to the target
exactly. The function should be strict enough for this final jump to not be
noticeable.

## Non-numeric types

Slick can be used to animate non-numeric types as long as they behave like
vectors and have their addition and multiplication operators defined. Note that
a stop function has to be provided in this case.
