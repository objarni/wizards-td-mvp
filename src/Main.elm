module Main exposing (main)

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta)
import Path exposing (..)
import TypedSvg exposing (..)
import TypedSvg.Attributes as Attributes
import TypedSvg.Events as Events
import TypedSvg.Types exposing (..)


main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    let
        path =
            Path
                (Segment ( 0, 840 ) ( 130, 758 ))
                [ ( 430, 280 )
                , ( 610, 270 )
                , ( 900, 640 )
                , ( 1081, 770 )
                ]

        creep =
            Creep path 0
    in
    ( { creep = creep }, Cmd.none )


type Msg
    = Tick Float
    | HireWizard


subscriptions _ =
    onAnimationFrameDelta Tick


update msg { creep } =
    let
        (Creep path distance) =
            creep

        nextModel =
            case msg of
                Tick delta ->
                    Creep path (distance + delta / 20)

                HireWizard ->
                    Creep path (distance - 20)
    in
    ( { creep = nextModel }, Cmd.none )


type Creep
    = Creep Path Distance


viewBlob x y =
    image
        [ Attributes.xlinkHref "assets/green-blob.apng"
        , Attributes.width <| px 70
        , Attributes.height <| px 110
        , Attributes.x <| px (x - 70 / 2)
        , Attributes.y <| px (y - 110)
        ]
        []


viewTower x y =
    rect
        [ Attributes.width <| px 100
        , Attributes.height <| px 150
        , Attributes.x <| px x
        , Attributes.y <| px y
        , Attributes.fillOpacity <| Opacity 0.5
        , Events.onClick <| HireWizard
        ]
        []


view { creep } =
    let
        (Creep path distance) =
            creep

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
        , viewBlob x y
        , viewTower 465 345
        , image
            [ Attributes.xlinkHref "assets/druid.png"
            , Attributes.width <| px 111
            , Attributes.height <| px 122
            , Attributes.x <| px (x - 111 / 2)
            , Attributes.y <| px (y - 122)
            ]
            []
        ]
