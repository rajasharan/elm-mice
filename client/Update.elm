module Update exposing (update)

import Window
import Mouse

import Types exposing (..)
import Utils exposing (..)
import Subscription exposing (send)
import Decoders exposing (decodePoint, decodeSocketMsg)
import Encoders exposing (encodeSocketMsg)
import Clients exposing (drawClient)

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    --let m = Debug.log "update-model" model in
    case message of
        Window size -> ( setSize size model, nop )
        Error err -> ( model, print err )
        TouchStart -> ( model, nop )
        TouchMove pos -> ( model, sendPosition pos model )
        TouchEnd -> ( model, sendCancel model )
        Listen str -> ( drawClient (decodeSocketMsg str) model, nop )

sendPosition : Mouse.Position -> Model -> Cmd Msg
sendPosition pos m =
    let 
        normalizePoint' = normalizePoint m.size
        (x, y) = normalizePoint' <| convertMouseToCanvasCoord pos m.size
    in
        send m.server <| encodeSocketMsg {id = m.id, kind = Point, x = x, y = y }

sendCancel : Model -> Cmd Msg
sendCancel m =
    send m.server <| encodeSocketMsg {id = m.id, kind = Cancel, x = 0.0, y = 0.0}
