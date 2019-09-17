-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module StarWars.Union.CharacterUnion exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (FragmentSelectionSet(..), SelectionSet(..))
import Json.Decode as Decode
import StarWars.InputObject
import StarWars.Interface
import StarWars.Object
import StarWars.Scalar
import StarWars.ScalarCodecs
import StarWars.Union


type alias Fragments decodesTo =
    { onHuman : SelectionSet decodesTo StarWars.Object.Human
    , onDroid : SelectionSet decodesTo StarWars.Object.Droid
    }


{-| Build up a selection for this Union by passing in a Fragments record.
-}
fragments :
    Fragments decodesTo
    -> SelectionSet decodesTo StarWars.Union.CharacterUnion
fragments selections =
    Object.exhuastiveFragmentSelection
        [ Object.buildFragment "Human" selections.onHuman
        , Object.buildFragment "Droid" selections.onDroid
        ]


{-| Can be used to create a non-exhuastive set of fragments by using the record
update syntax to add `SelectionSet`s for the types you want to handle.
-}
maybeFragments : Fragments (Maybe decodesTo)
maybeFragments =
    { onHuman = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onDroid = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    }
