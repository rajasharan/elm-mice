module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Text exposing (..)
import Color exposing (rgb)
import FontAwesome exposing (server, eraser)

import Types exposing (..)
import Decoders exposing (..)

view : Model -> Html Msg
view model =
  drawCanvas model

drawCanvas : Model -> Html Msg
drawCanvas m =
  let
    --c = Debug.log "draw" m.clients
    w = m.size.width
    h = m.size.height

    img x y = image 24 24 "pointer.png"
              |> container w h (middleAt (absolute <| x + w//2) (absolute <| h//2 - y))
              |> opacity 0.3
    
    positions = List.map (\c -> c.position) m.clients --|> Debug.log "pos"
    imgs = List.map (\(x,y) -> img (round x) (round y)) positions --|> Debug.log "imgs"
    forms = List.map (\e -> toForm e) imgs

  in
    div []
      [ div
          [ class "canvas"
          , onWithOptions
              "touchstart"
              { stopPropagation = True, preventDefault = True }
              touchStartDecoder
          , onWithOptions
              "touchmove"
              { stopPropagation = True, preventDefault = True }
              touchMoveDecoder
          , on "touchend" touchEndDecoder
          , on "mousemove" mouseMoveDecoder
          , on "mouseleave" mouseEndDecoder
          ]
          [ collage w h (banner m :: forms)
            |> toHtml
          ]
      , githubRibbon
      ]

banner : Model -> Form
banner model =
  fromString "Move all your mice !!!"
  |> bold
  |> monospace
  |> Text.height 40
  |> line Under
  |> justified
  |> container model.size.width model.size.height (midTopAt (relative 0.5) (relative 0.01))
  |> toForm

githubRibbon : Html Msg
githubRibbon =
  a [href "https://github.com/rajasharan/elm-mice"]
    [img
      [ Html.Attributes.style [("position", "absolute"), ("top", "0"), ("right", "0"), ("border", "0")]
      , src "https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67"
      , alt "Fork me on Github"
      , attribute "data-canonical-src" "https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"
      ] []
    ]
