module Main exposing (main)

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta)
import Geometry exposing (..)
import Html exposing (div, text)
import Html.Attributes
import Html.Events exposing (onClick)
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


init : () -> ( Model { creeps : List Creep, wizard : Bool }, Cmd Msg )
init () =
    level1


level1 =
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
    ( GameScreen { creeps = [ creep ], wizard = False }, Cmd.none )


type Model a
    = StartScreen
    | GameScreen a


type Msg
    = Tick Float
    | HireWizard
    | StartScreenClick


subscriptions model =
    case model of
        StartScreen ->
            Sub.none

        GameScreen _ ->
            onAnimationFrameDelta Tick


update msg m =
    case m of
        GameScreen model ->
            updateGameScreen msg model

        StartScreen ->
            case msg of
                StartScreenClick ->
                    level1

                _ ->
                    ( m, Cmd.none )


updateCreep delta (Creep path distance) =
    Creep path (distance + delta / 20)


updateGameScreen msg model =
    let
        hitByWizard hasWizard (Creep path pathDistance) =
            let
                creepPos =
                    getCoordinate path pathDistance

                wizardPos =
                    towerCoordinate Center
            in
            if distance creepPos wizardPos < 300 then
                hasWizard

            else
                False

        nextCreeps =
            case msg of
                Tick delta ->
                    List.map (updateCreep delta) <| List.filter (not << hitByWizard model.wizard) model.creeps

                _ ->
                    model.creeps

        nextWizard =
            case msg of
                HireWizard ->
                    True

                _ ->
                    model.wizard
    in
    ( GameScreen { model | creeps = nextCreeps, wizard = nextWizard }, Cmd.none )


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


clickableOverlay towerPos =
    let
        ( x, y ) =
            towerCoordinate towerPos
    in
    rect
        [ Attributes.width <| px 100
        , Attributes.height <| px 150
        , Attributes.x <| px (x - 50)
        , Attributes.y <| px (y - 100)
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
    | Center
    | West
    | East


view model =
    case model of
        GameScreen { creeps, wizard } ->
            let
                wizards =
                    wizardsView
                        (if wizard then
                            [ Center ]

                         else
                            []
                        )

                renderedCreeps =
                    creepsView creeps

                gui =
                    if wizard then
                        []

                    else
                        [ clickableOverlay Center ]
            in
            svg
                [ Attributes.viewBox 0 0 1081 1081
                , Attributes.width <| num 1081
                , Attributes.height <| num 1081
                ]
                ([ background ]
                    ++ wizards
                    ++ renderedCreeps
                    ++ [ foreground ]
                    ++ gui
                )

        StartScreen ->
            div
                [ Html.Attributes.style "margin" "auto"
                , Html.Attributes.style "width" "15em"
                , Html.Attributes.style "text-align" "center"
                , onClick StartScreenClick
                ]
                [ text "Click to Start!" ]


towerCoordinate towerPos =
    case towerPos of
        Center ->
            ( 514, 450 )

        West ->
            ( 130, 500 )

        East ->
            ( 955, 540 )

        North ->
            ( 670, 140 )
