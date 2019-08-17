module Example exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


type alias Point =
    ( Float, Float )


type Path
    = Line Point Point


getCoordinate (Line start end) a =
    case a of
        0 ->
            start

        _ ->
            end


suite : Test
suite =
    describe "Path"
        [ test "starts at startpoint" <|
            let
                path =
                    Line ( 0, 0 ) ( 100, 150 )
            in
            \_ -> getCoordinate path 0 |> Expect.equal ( 0, 0 )
        , test "ends at endpoint" <|
            let
                path =
                    Line ( 0, 0 ) ( 100, 0 )
            in
            \_ -> getCoordinate path 100 |> Expect.equal ( 100, 0 )
        ]
