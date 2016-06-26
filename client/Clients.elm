module Clients exposing (drawClient)

import List.Extra exposing (..)

import Types exposing (..)
import Utils exposing (..)

drawClient : Result String SocketMsg -> Model -> Model
drawClient result model =
    case result of
        Err e ->
            let p = Debug.log "decode" e
            in model
        Ok s ->
            --let p = Debug.log "decode" s in
            drawClient' s model

drawClient' : SocketMsg -> Model -> Model
drawClient' socket model =
    case socket.kind of
        Initial -> { model | clients = addClient socket.id model.clients, id = socket.id }
        Cancel -> { model | clients = deleteClient socket.id model.clients }
        Point -> addPointToClient socket.id socket.x socket.y model

addClient : Id -> List Client -> List Client
addClient id clients =
    let
        c' = find (\c -> c.id == id) clients 
    in
        case c' of
            Nothing -> { id = id, position = (-9999.0, -9999.0) } :: clients
            Just client -> clients

deleteClient : Id -> List Client -> List Client
deleteClient id clients = deleteIf (\c -> c.id == id) clients

addPointToClient : Id -> Float -> Float -> Model -> Model
addPointToClient id x y model =
    let
        point = denormalizePoint model.size (x, y) --|> Debug.log "newpoint"
    in
        { model | clients = modifyClient id point model.clients } --|> Debug.log "add"

modifyClient : Id -> (Float, Float) -> List Client -> List Client
modifyClient id point clients =
    let
        --p = point |> Debug.log "p"
        --i = id |> Debug.log "id"
        c' = find (\c -> c.id == id) clients
    in
        case c' of
            Nothing -> { id = id, position = point } :: clients
            Just client ->
                replaceIf (\c -> c.id == id) { client | position = point } clients
