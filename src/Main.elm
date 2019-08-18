module Main exposing (main)

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta)
import Path exposing (..)
import TypedSvg exposing (..)
import TypedSvg.Attributes as Attributes
import TypedSvg.Types exposing (..)


main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    ( Creep (Line ( 0, 0 ) ( 1081, 1081 )) 0, Cmd.none )


type Msg
    = Tick Float


subscriptions model =
    onAnimationFrameDelta Tick


update (Tick delta) (Creep path distance) =
    ( Creep path (distance + delta / 100), Cmd.none )


type Creep
    = Creep Path Distance


view (Creep path distance) =
    let
        ( x, y ) =
            getCoordinate path distance
    in
    svg
        [ Attributes.viewBox 0 0 1081 1081
        , Attributes.width <| num 1081
        , Attributes.height <| num 1081
        ]
        [ image
            [ Attributes.xlinkHref "assets/background.png"
            , Attributes.width <| px 1081
            , Attributes.height <| px 1081
            ]
            []
        , image
            [ Attributes.xlinkHref "assets/green-blob.apng"
            , Attributes.width <| px 70
            , Attributes.height <| px 110
            , Attributes.x <| px x
            , Attributes.y <| px y
            ]
            []
        ]
