module Path exposing (Distance, Path(..), Segment(..), getCoordinate, getLength)

import Debug exposing (todo)


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


getCoordinate (Path ((Segment ( startX, startY ) (( endX, endY ) as end)) as segment) points) distance =
    let
        segmentLength =
            getLength segment
    in
    case ( points, segmentLength >= distance ) of
        ( _, True ) ->
            let
                fraction =
                    distance / segmentLength
            in
            ( interpolate startX endX fraction
            , interpolate startY endY fraction
            )

        ( point :: _, _ ) ->
            getCoordinate (Path (Segment end point) []) (distance - segmentLength)

        ( _, _ ) ->
            todo "hmm"
