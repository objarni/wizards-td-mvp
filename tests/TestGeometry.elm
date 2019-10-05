module TestGeometry exposing (suite)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Geometry exposing (..)
import Test exposing (..)


verticalLine length =
    Segment ( 0, 0 ) ( 0, length )


horizontalLine length =
    Segment ( 0, 0 ) ( length, 0 )


diagonalLine x y =
    Segment ( 0, 0 ) ( x, y )


multiSegmentPath =
    Path (Segment ( 0, 0 ) ( 100, 0 )) [ ( 100, 100 ), ( 0, 100 ) ]


suite : Test
suite =
    describe "Geometry"
        [ describe "Path"
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
                , test "point at third segment in multi segment path" <|
                    \() -> getCoordinate multiSegmentPath 250 |> Expect.equal ( 50, 100 )
                , test "midpoint is in between" <|
                    \() -> getCoordinate (Path (verticalLine 100) []) 50 |> Expect.equal ( 0, 50 )
                , test "point beyond endpoint is endpoint" <|
                    \() -> getCoordinate (Path (verticalLine 100) []) 101 |> Expect.equal ( 0, 100 )
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
        , describe "Distance"
            [ test "distance between points on the x axis is the difference on that axis" <|
                \() -> distance ( 100, 0 ) ( 200, 0 ) |> Expect.within (Absolute 0.1) 100
            , test "distance between points on the y axis is the difference on that axis" <|
                \() -> distance ( 0, 100 ) ( 0, 250 ) |> Expect.within (Absolute 0.1) 150
            , test "distance between origin and a point is the length of the vector" <|
                \() -> distance ( 0, 0 ) ( 4, 3 ) |> Expect.within (Absolute 0.1) 5
            ]
        ]
