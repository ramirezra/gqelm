module Main exposing (main)

import Brand
import Browser
import Debug
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import RemoteData exposing (RemoteData)
import StarWars.Interface exposing (Character)
import StarWars.Interface.Character as Character
import StarWars.Object.Human
import StarWars.Query as Query
import StarWars.Scalar exposing (Id)



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }



-- MODEL


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response



-- type alias GraphqlData a =
--     RemoteData Graphql.Http.Error a


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )


type alias Response =
    Character


type alias Character =
    { name : String
    , avatarUrl : String
    , id : Id
    , friends : List String
    }



-- Query  hero {
--     { name
--     id
--     friends {
--         name
--         }
--     }
-- }


query : SelectionSet Response RootQuery
query =
    Query.hero identity
        (SelectionSet.succeed Character
            |> with Character.name
            |> with Character.avatarUrl
            |> with Character.id
            |> with (Character.friends Character.name)
        )


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "https://elm-graphql.herokuapp.com"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)



-- UPDATE


type Msg
    = GotResponse Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    case model of
        RemoteData.NotAsked ->
            { title = "Not Asked"
            , body =
                [ div [] [ Html.text "Not Asked" ]
                ]
            }

        RemoteData.Loading ->
            { title = "Loading"
            , body =
                [ div [] [ Html.text "Loading" ]
                ]
            }

        RemoteData.Failure err ->
            { title = "Error"
            , body =
                [ div [] [ Html.text (Debug.toString err) ]
                ]
            }

        RemoteData.Success data ->
            { title = "Hello"
            , body =
                -- [ div [] [ Html.text data.name ]
                -- , div [] [ Html.text <| Debug.toString data.id ]
                -- , div [] (List.map Html.text data.friends)
                -- ]
                [ characterCard data ]
            }


characterCard data =
    Element.layout [] <|
        Element.column []
            [ Element.row
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.spacing 10
                , Element.paddingXY 0 10
                , Element.centerX
                ]
                [ Element.column
                    [ Element.width Element.fill
                    , Brand.defaultPadding
                    , Background.color Brand.cardColor
                    , Border.rounded 10
                    , Border.shadow
                        { offset = ( 1, 1 )
                        , size = 4
                        , blur = 10
                        , color = Brand.shadowColor
                        }
                    ]
                    [ Element.image
                        [ Element.width (Element.px 100)
                        , Border.rounded 50
                        , Element.clip
                        , Element.alignTop
                        , Element.centerX
                        ]
                        { src = data.avatarUrl
                        , description = "Avatar"
                        }
                    , Element.el
                        [ Element.alignTop
                        , Font.bold
                        , Element.padding 5
                        ]
                      <|
                        Element.text data.name
                    , Element.el
                        [ Element.alignLeft
                        , Font.color Brand.subtleTextColor
                        ]
                      <|
                        Element.text "Friends:"
                    , Element.column [ Element.centerX ] <| List.map Element.text data.friends
                    ]
                ]
            ]
