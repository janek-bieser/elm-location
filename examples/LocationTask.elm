module Main (..) where

import Location exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import StartApp
import Task exposing (Task)
import Signal


type Action
    = LocationChange (Maybe Location)
    | GoTo String


type alias Model =
    Location


main : Signal.Signal Html
main =
    app.html


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs =
            [ Signal.map (LocationChange << Just) Location.location
            ]
        }


init : ( Model, Effects Action )
init =
    ( Location.empty, mapEffect Location.currentLocation LocationChange )


view : Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h1 [] [ text "Location Task Example" ]
        , p [] [ text <| toString model ]
        , p [] [ text "Click the button to navigate. Use '<-' and '->' of you browser afterwards." ]
        , button
            [ onClick address (GoTo "/example?query=test") ]
            [ text "Go To: /example?query=test" ]
        ]


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        LocationChange maybeLoc ->
            case maybeLoc of
                Just loc ->
                    ( loc, Effects.none )

                Nothing ->
                    ( model, Effects.none )

        GoTo url ->
            ( model, mapEffect (Location.pushState url) LocationChange )


mapEffect : Task x Location -> (Maybe Location -> y) -> Effects y
mapEffect task mapper =
    task
        |> Task.toMaybe
        |> Task.map mapper
        |> Effects.task


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
