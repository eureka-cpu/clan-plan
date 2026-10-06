module Main exposing (main)

import Browser
import Dict
import Flags exposing (Flags)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Http
import Survey.Api as Api
import Survey.Graph as Graph exposing (Choice)
import Survey.Pitch as Pitch
import Survey.Types exposing (AnswerStep, FlatAnswers, Phase(..), emptyFlatAnswers, setField)
import Survey.View as View


type alias Model =
    { phase : Phase
    , history : List AnswerStep -- most-recent-first
    , flat : FlatAnswers
    , respondentName : String
    , productName : String
    , comment : String
    , config : Flags
    }


type Msg
    = SelectedChoice Choice
    | UpdatedRespondentName String
    | UpdatedProductName String
    | UpdatedComment String
    | ClickedBack
    | ClickedSubmit
    | ClickedEditFromError
    | ClickedRestart
    | GotSubmitResult (Result Http.Error ())


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { phase = Asking Graph.rootNodeId
      , history = []
      , flat = emptyFlatAnswers
      , respondentName = ""
      , productName = ""
      , comment = ""
      , config = flags
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectedChoice choice ->
            case model.phase of
                Asking nodeId ->
                    let
                        step =
                            { questionId = nodeId
                            , choiceId = choice.id
                            , choiceLabel = choice.label
                            , field = choice.field
                            }

                        newFlat =
                            case choice.field of
                                Just field ->
                                    setField field choice.id model.flat

                                Nothing ->
                                    model.flat

                        newPhase =
                            case choice.next of
                                Just nextId ->
                                    Asking nextId

                                Nothing ->
                                    Review
                    in
                    ( { model | history = step :: model.history, flat = newFlat, phase = newPhase }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        UpdatedRespondentName name ->
            ( { model | respondentName = name }, Cmd.none )

        UpdatedProductName name ->
            ( { model | productName = name }, Cmd.none )

        UpdatedComment comment ->
            ( { model | comment = comment }, Cmd.none )

        ClickedBack ->
            case model.phase of
                SubmitFailed _ ->
                    ( { model | phase = Review }, Cmd.none )

                _ ->
                    ( popLastAnswer model, Cmd.none )

        ClickedEditFromError ->
            ( { model | phase = Review }, Cmd.none )

        ClickedSubmit ->
            ( { model | phase = Submitting }
            , Api.submit model.config
                model.flat
                (List.reverse model.history)
                model.respondentName
                model.productName
                model.comment
                GotSubmitResult
            )

        ClickedRestart ->
            ( { model
                | phase = Asking Graph.rootNodeId
                , history = []
                , flat = emptyFlatAnswers
                , respondentName = ""
                , productName = ""
                , comment = ""
              }
            , Cmd.none
            )

        GotSubmitResult result ->
            case result of
                Ok () ->
                    ( { model | phase = Submitted }, Cmd.none )

                Err httpError ->
                    ( { model | phase = SubmitFailed (describeError httpError) }, Cmd.none )


{-| Pops the most recent answer and recomputes `flat` by refolding the
remaining history, so going "Back" correctly un-sets whichever field (if any)
the popped choice had set.
-}
popLastAnswer : Model -> Model
popLastAnswer model =
    case model.history of
        [] ->
            model

        step :: rest ->
            { model
                | history = rest
                , flat =
                    List.foldl
                        (\s acc ->
                            case s.field of
                                Just field ->
                                    setField field s.choiceId acc

                                Nothing ->
                                    acc
                        )
                        emptyFlatAnswers
                        (List.reverse rest)
                , phase = Asking step.questionId
            }


describeError : Http.Error -> String
describeError httpError =
    case httpError of
        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.Timeout ->
            "The request timed out. Check your connection and try again."

        Http.NetworkError ->
            "Network error — check config.js has the right Supabase URL and that you're online."

        Http.BadStatus status ->
            "The server rejected the submission (status "
                ++ String.fromInt status
                ++ "). Check config.js has a valid anon key and that db/schema.sql has been run."

        Http.BadBody body ->
            "Unexpected response: " ++ body


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.phase of
            Asking nodeId ->
                case Dict.get nodeId Graph.questionGraph of
                    Just node ->
                        View.viewQuestion
                            { onChoice = SelectedChoice
                            , onBack = ClickedBack
                            , showBack = not (List.isEmpty model.history)
                            }
                            node

                    Nothing ->
                        View.viewError
                            { message = "Unknown question: " ++ nodeId
                            , onEdit = ClickedEditFromError
                            , onRetry = ClickedRestart
                            }

            Review ->
                View.viewReview
                    { orderedHistory = List.reverse model.history
                    , pitch = Pitch.generate model.productName model.flat
                    , productName = model.productName
                    , onProductNameInput = UpdatedProductName
                    , respondentName = model.respondentName
                    , onRespondentNameInput = UpdatedRespondentName
                    , comment = model.comment
                    , onCommentInput = UpdatedComment
                    , canSubmit =
                        not (String.isEmpty (String.trim model.respondentName))
                            && not (String.isEmpty (String.trim model.productName))
                    , onBack = ClickedBack
                    , onSubmit = ClickedSubmit
                    }

            Submitting ->
                View.viewSubmitting

            Submitted ->
                View.viewSubmitted ClickedRestart

            SubmitFailed message ->
                View.viewError
                    { message = message
                    , onEdit = ClickedEditFromError
                    , onRetry = ClickedSubmit
                    }
        ]
