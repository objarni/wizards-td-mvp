module TestPath exposing (suite)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Path exposing (..)
import Test exposing (..)


verticalLine length =
    Segment ( 0, 0 ) ( 0, length )


horizontalLine length =
    Segment ( 0, 0 ) ( length, 0 )


diagonalLine x y =
    Segment ( 0, 0 ) ( x, y )


multiSegmentPath =
    Path (Segment ( 0, 0 ) ( 100, 0 )) [ ( 100, 100 ) ]


suite : Test
suite =
    describe "Path"
        [ describe "getCoordinate"
            [ test "starts at start point" <|
                let
                    path =
                        Path (Segment ( 0, 0 ) ( 100, 150 )) []
                in
                \() -> getCoordinate path 0 |> Expect.equal ( 0, 0 )
            , test "ends at endpoint" <|
                let
                    path =
                        Path (Segment ( 0, 0 ) ( 100, 0 )) []
                in
                \() -> getCoordinate path 100 |> Expect.equal ( 100, 0 )
            , test "point at first segment in multi segment path" <|
                \() -> getCoordinate multiSegmentPath 50 |> Expect.equal ( 50, 0 )
            , test "point at second segment in multi segment path" <|
                \() -> getCoordinate multiSegmentPath 150 |> Expect.equal ( 100, 50 )
            , test "midpoint is in between" <|
                \() -> getCoordinate (Path (verticalLine 100) []) 50 |> Expect.equal ( 0, 50 )
            ]
        , describe "getLength"
            [ test "length of vertical line" <|
                \() -> getLength (verticalLine 50) |> Expect.equal 50
            , test "length of horizontal line" <|
                \() -> getLength (horizontalLine 75) |> Expect.equal 75
            , test "length of diagonal line" <|
                \() -> getLength (diagonalLine 3 4) |> Expect.equal 5
            , test "length of line not starting in origin" <|
                \() -> getLength (Segment ( 1, 1 ) ( 4, 5 )) |> Expect.within (Absolute 0.1) 5
            ]
        ]
