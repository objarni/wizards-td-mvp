module Path exposing (Distance, Path(..), Point, getCoordinate, getLength)


type alias Distance =
    Float


type alias Point =
    ( Float, Float )


type Path
    = Line Point Point


getLength (Line ( startX, startY ) ( endX, endY )) =
    let
        dx =
            endX - startX

        dy =
            endY - startY
    in
    sqrt (dx ^ 2 + dy ^ 2)


interpolate start end fraction =
    start + fraction * (end - start)


getCoordinate ((Line ( startX, startY ) ( endX, endY )) as path) distance =
    let
        fraction =
            distance / getLength path
    in
    ( interpolate startX endX fraction
    , interpolate startY endY fraction
    )
