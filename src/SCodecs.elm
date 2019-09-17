module SCodecs exposing (..)

import Json.Decode as Decode exposing (Decoder)
import StarWars.Scalar exposing (defaultCodecs)


type alias Id =
    StarWars.Scalar.Id


type alias PosixTime =
    StarWars.Scalar.PosixTime


codecs : StarWars.Scalar.Codecs Id PosixTime
codecs =
    StarWars.Scalar.defineCodecs
        { codecId = defaultCodecs.codecId
        , codecPosixTime = defaultCodecs.codecPosixTime
        }
