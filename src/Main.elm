module Main exposing (main)

import Browser exposing (element)
import Html exposing (text)


main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    ( (), Cmd.none )


subscriptions model =
    Sub.none


update msg model =
    ( model, Cmd.none )


view _ =
    text "hello world!"
