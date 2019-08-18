module Path exposing (Distance, Path(..), Segment(..), getCoordinate, getLength)


type alias Distance =
    Float


type alias Point =
    ( Float, Float )


type Segment
    = Segment Point Point


type Path
    = Path Segment (List Point)


getLength (Segment ( startX, startY ) ( endX, endY )) =
    let
        dx =
            endX - startX

        dy =
            endY - startY
    in
    sqrt (dx ^ 2 + dy ^ 2)


interpolate start end fraction =
    start + fraction * (end - start)


getCoordinate (Path ((Segment ( startX, startY ) ( endX, endY )) as path) _) distance =
    let
        fraction =
            distance / getLength path
    in
    ( interpolate startX endX fraction
    , interpolate startY endY fraction
    )
