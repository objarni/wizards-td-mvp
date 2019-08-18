module TestPath exposing (suite)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Path exposing (..)
import Test exposing (..)


verticalLine length =
    Line ( 0, 0 ) ( 0, length )


horisontalLine length =
    Line ( 0, 0 ) ( length, 0 )


diagonalLine x y =
    Line ( 0, 0 ) ( x, y )


suite : Test
suite =
    describe "Path"
        [ describe "getCoordinate"
            [ test "starts at startpoint" <|
                let
                    path =
                        Line ( 0, 0 ) ( 100, 150 )
                in
                \() -> getCoordinate path 0 |> Expect.equal ( 0, 0 )
            , test "ends at endpoint" <|
                let
                    path =
                        Line ( 0, 0 ) ( 100, 0 )
                in
                \() -> getCoordinate path 100 |> Expect.equal ( 100, 0 )
            , test "midpoint is in between" <|
                \() -> getCoordinate (verticalLine 100) 50 |> Expect.equal ( 0, 50 )
            ]
        , describe "getLength"
            [ test "length of vertical line" <|
                \() -> getLength (verticalLine 50) |> Expect.equal 50
            , test "length of horisontal line" <|
                \() -> getLength (horisontalLine 75) |> Expect.equal 75
            , test "length of diagonal line" <|
                \() -> getLength (diagonalLine 3 4) |> Expect.equal 5
            , test "length of line not starting in origo" <|
                \() -> getLength (Line ( 1, 1 ) ( 4, 5 )) |> Expect.within (Absolute 0.1) 5
            ]
        ]
