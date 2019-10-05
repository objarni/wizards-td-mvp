module Geometry exposing (Distance, Path(..), Segment(..), distance, getCoordinate, getLength)

import Basics


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


getCoordinate (Path segment points) pathDistance =
    let
        (Segment start end) =
            segment

        ( startX, startY ) =
            start

        ( endX, endY ) =
            end

        segmentLength =
            getLength segment
    in
    case ( points, segmentLength >= pathDistance ) of
        ( _, True ) ->
            let
                fraction =
                    pathDistance / segmentLength
            in
            ( interpolate startX endX fraction
            , interpolate startY endY fraction
            )

        ( point :: rest, _ ) ->
            getCoordinate (Path (Segment end point) rest) (pathDistance - segmentLength)

        ( _, _ ) ->
            end


distance ( x1, y1 ) ( x2, y2 ) =
    sqrt <| (x2 - x1) ^ 2 + (y2 - y1) ^ 2
