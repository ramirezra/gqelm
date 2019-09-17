module Main exposing (main)

import Browser
import Debug
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
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


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )


type alias Response =
    Character


type alias Character =
    { name : String
    , id : Id
    , friends : List String
    }


query : SelectionSet Response RootQuery
query =
    Query.hero identity characterInfoSelection



-- characterInfo on Characater {
--     { name
--     id
--     friends {
--         name
--         }
--     }
-- }


characterInfoSelection : SelectionSet Character StarWars.Interface.Character
characterInfoSelection =
    SelectionSet.map3 Character Character.name Character.id (Character.friends Character.name)


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
    { title = "Hello"
    , body = [ div [] [ Html.text (Debug.toString model) ] ]
    }
