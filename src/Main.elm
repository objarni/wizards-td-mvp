module Main exposing (main)

import Browser exposing (element)
import Html exposing (text)
import TypedSvg exposing (..)
import TypedSvg.Attributes exposing (..)
import TypedSvg.Types exposing (..)


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
    svg
        [ viewBox 0 0 1081 1081
        , width <| num 1081
        , height <| num 1081
        ]
        [ image
            [ xlinkHref "assets/background.png"
            , width <| px 1081
            , height <| px 1081
            ]
            []
        , image
            [ xlinkHref "assets/green-blob.apng"
            , width <| px 70
            , height <| px 110
            , x <| px 200
            , y <| px 500
            ]
            []
        ]
