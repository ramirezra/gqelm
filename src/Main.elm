module Main exposing (main)

import Brand
import Browser
import Debug
import Element 
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html)
import RemoteData exposing (RemoteData)
import StarWars.Object exposing (Human)
import StarWars.Object.Human as Human   
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
    Maybe Human


type alias Human =
    { name : String
    , avatarUrl : String
    , homePlanet : Maybe String
    }



-- , id : Id
-- , friends : List String
-- Query  hero {
--     { name
--     id
--     friends {
--         name
--         }
--     }
-- }


query : Id -> SelectionSet Response RootQuery
query id =
    Query.human { id = id } <|
        SelectionSet.map3 Human
            Human.name
            Human.avatarUrl
            Human.homePlanet



-- Human.id
-- (Human.friends Character.name)
-- Human.homePlanet


makeRequest : Cmd Msg
makeRequest =
    StarWars.Scalar.Id "1003"
        |> query
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
                [ Html.div [] [ Html.text "Not Asked" ]
                ]
            }

        RemoteData.Loading ->
            { title = "Loading"
            , body =
                [ Html.div [] [ Html.text "Loading" ]
                ]
            }

        RemoteData.Failure err ->
            { title = "Error"
            , body =
                [ Html.div [] [ Html.text (Debug.toString err) ]
                ]
            }

        RemoteData.Success data ->
            { title = "Star Wars Cards"
            , body = [ characterCard data]
            }



characterCard : Response -> Html Msg
characterCard response =
    let
       data = case response of
           Nothing -> (Human "" "" (Just ""))               
       
           Just human -> human
        
    in
    
    Element.layout [ Element.centerX ] <|
        Element.column [ Element.centerX, Element.centerY ]
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
                        case data.homePlanet of
                            Just homePlanet ->
                                Element.text homePlanet

                            Nothing ->
                                Element.none
                    ]
                ]                                                                                               
            ]
