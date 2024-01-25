# vshmup

## Installation

* download `LÖVE` 11 from <https://love2d.org/>
* clone this repository
* run the game as described [here](https://love2d.org/wiki/Getting_Started)

## Playing

* steer the ship with cursor left and right keys
* shot with space key
* don't die and play forever

## some notes

### calculate shot angle in radians

- `x_dist` and `y_dist` are known
- `β` = 90 deg. (or PI / 2)

- formulas to find direction:

```
b = sqrt(x_dist^2 + y_dist^2 - 2 * x_dist * y_dist * cos(β))
γ = asin( (sin(β) / b) * y_dist )
```

```
γ = asin( (sin(β) / (sqrt(x_dist^2 + y_dist^2 - 2 * x_dist * y_dist * cos(β)))) * y_dist)
```

- simplify due to `β` = 90 deg:

```
b = sqrt(x_dist^2 + y_dist^2 - 2 * x_dist * y_dist * cos(pi/2))
γ = asin(y_dist / b)
```

```
γ = asin(y_dist / (sqrt(x_dist^2 + y_dist^2 - 2 * x_dist * y_dist * cos(pi/2))))
```

- still too complex, unlikely to be useful in the code
