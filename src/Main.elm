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
    ( { creep = creep, wizard = False }, Cmd.none )


type Msg
    = Tick Float
    | HireWizard


subscriptions _ =
    onAnimationFrameDelta Tick


update msg model =
    let
        (Creep path distance) =
            model.creep

        nextCreep =
            case msg of
                Tick delta ->
                    Creep path (distance + delta / 20)

                HireWizard ->
                    model.creep

        nextWizard =
            case msg of
                Tick _ ->
                    model.wizard

                HireWizard ->
                    True
    in
    ( { model | creep = nextCreep, wizard = nextWizard }, Cmd.none )


type Creep
    = Creep Path Distance


background =
    image
        [ Attributes.xlinkHref "assets/background.png"
        , Attributes.width <| px 1081
        , Attributes.height <| px 1081
        ]
        []


foreground =
    image
        [ Attributes.xlinkHref "assets/foreground.png"
        , Attributes.width <| px 1081
        , Attributes.height <| px 1081
        ]
        []


blobView x y =
    image
        [ Attributes.xlinkHref "assets/green-blob.apng"
        , Attributes.width <| px 70
        , Attributes.height <| px 110
        , Attributes.x <| px (x - 70 / 2)
        , Attributes.y <| px (y - 110)
        ]
        []


druidView x y =
    image
        [ Attributes.xlinkHref "assets/druid.png"
        , Attributes.width <| px 111
        , Attributes.height <| px 122
        , Attributes.x <| px (x - 111 / 2)
        , Attributes.y <| px (y - 122)
        ]
        []


clickableOverlay x y =
    rect
        [ Attributes.width <| px 100
        , Attributes.height <| px 150
        , Attributes.x <| px x
        , Attributes.y <| px y
        , Attributes.fillOpacity <| Opacity 0.2
        , Events.onClick <| HireWizard
        ]
        []


creepsView creeps =
    let
        creepView (Creep path distance) =
            let
                ( x, y ) =
                    getCoordinate path distance
            in
            blobView x y
    in
    List.map creepView creeps


wizardsView wizards =
    let
        wizardView _ =
            druidView 500 395
    in
    List.map wizardView wizards


type TowerPos
    = North
    | South


view { creep, wizard } =
    let
        wizards =
            wizardsView
                (if wizard then
                    [ South ]

                 else
                    []
                )

        creeps =
            creepsView [ creep ]

        gui =
            if wizard then
                []

            else
                [ clickableOverlay 465 345 ]
    in
    svg
        [ Attributes.viewBox 0 0 1081 1081
        , Attributes.width <| num 1081
        , Attributes.height <| num 1081
        ]
        ([ background ]
            ++ wizards
            ++ creeps
            ++ [ foreground ]
            ++ gui
        )
