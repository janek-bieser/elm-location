# elm-location

elm-location is a binding to `window.location` and
`window.history`. You can use it to obtain information about the
current location (e.g. path, hash or search query) and manipulate the
browser history.

**Note: This project is in the very early stages and used for personal
 stuff only. So don't use it in production please.**

## How to use it

### Location Object

```elm
type alias Location =
    { path : String
    , hash : String
    , search : String
    }
```

### Location Signal

[Full Example](./examples/LocationSignal.elm)

```elm
import Location exposing (Location)
import Html exposing (..)
import Signal

main : Signal Html
main =
    Signal.map view Location.location
    
view : Location -> Html
view location =
    p [] [ text <| toString location ]
```

### Location Tasks

[Full Example](./examples/LocationTask.elm) on how to use the provided
tasks in combination with the
[StartApp](https://github.com/evancz/start-app) module and Effects
