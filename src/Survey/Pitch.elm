module Survey.Pitch exposing (generate)

import Survey.Types exposing (FlatAnswers)


{-| Builds the "[Product] is a [brand feel] [description] for [buyer]
that is [reason] at a [price point]." sentence from the respondent's answers.
`productName` is whatever the respondent has typed so far (falls back to
"This product" when blank, so the sentence stays readable before they fill
it in). Returns Nothing until every other piece it needs has been answered —
in practice that's always true by the time the Review screen is reached,
since both branches set all four fields before they terminate.
-}
generate : String -> FlatAnswers -> Maybe String
generate productName flat =
    Maybe.map4 (buildSentence productName) flat.subTarget flat.whyPay flat.pricingOrOwnership flat.brandArchetype


buildSentence : String -> String -> String -> String -> String -> String
buildSentence productName subTarget whyPay pricing brand =
    let
        name =
            if String.isEmpty (String.trim productName) then
                "This product"

            else
                String.trim productName

        ( brandArticle, brandPhrase ) =
            brandInfo brand

        ( priceArticle, pricePhrase ) =
            priceInfo pricing
    in
    name
        ++ " is "
        ++ brandArticle
        ++ " "
        ++ brandPhrase
        ++ " "
        ++ descriptionFor subTarget
        ++ " for "
        ++ buyerFor subTarget
        ++ " that is "
        ++ reasonFor whyPay
        ++ " at "
        ++ priceArticle
        ++ " "
        ++ pricePhrase
        ++ " price point."


brandInfo : String -> ( String, String )
brandInfo brand =
    case brand of
        "premium_cutting_edge" ->
            ( "a", "premium, cutting-edge" )

        "reliable_dependable" ->
            ( "a", "reliable, dependable" )

        "invisible_convenience" ->
            ( "an", "invisible, quietly convenient" )

        "nerd_hobbyist" ->
            ( "a", "nerdy, DIY" )

        "protective_security" ->
            ( "a", "protective, security-focused" )

        "affordable_practical" ->
            ( "an", "affordable, practical" )

        "smart_home_entertainment" ->
            ( "an", "all-in-one smart-home" )

        _ ->
            ( "a", "distinctively branded" )


descriptionFor : String -> String
descriptionFor subTarget =
    case subTarget of
        "web3" ->
            "deployment tool for Web3 infrastructure"

        "robotics_fleets" ->
            "fleet management tool"

        "nix_cicd" ->
            "CI/CD deployment tool"

        "home_lab" ->
            "home server platform"

        "home_security" ->
            "home security system"

        "personal_ai" ->
            "personal AI platform"

        "vibe_coded_hosting" ->
            "app hosting platform"

        _ ->
            "platform"


buyerFor : String -> String
buyerFor subTarget =
    case subTarget of
        "web3" ->
            "Web3 companies"

        "robotics_fleets" ->
            "robotics fleet operators"

        "nix_cicd" ->
            "Nix CI/CD-heavy businesses"

        "home_lab" ->
            "home-lab enthusiasts"

        "home_security" ->
            "security-focused households"

        "personal_ai" ->
            "personal-AI users"

        "vibe_coded_hosting" ->
            "people hosting AI-built apps"

        _ ->
            "its target buyers"


reasonFor : String -> String
reasonFor whyPay =
    case whyPay of
        "cheapest" ->
            "the cheapest"

        "fastest" ->
            "the fastest"

        "convenient" ->
            "the most convenient"

        "reliable" ->
            "the most reliable"

        _ ->
            "the best fit"


priceInfo : String -> ( String, String )
priceInfo pricing =
    case pricing of
        "premium" ->
            ( "a", "premium" )

        "affordable" ->
            ( "an", "affordable" )

        "self_host_free" ->
            ( "a", "free" )

        "self_host_donation" ->
            ( "a", "pay-what-you-want" )

        "pay_for_convenience" ->
            ( "a", "subscription" )

        "hardware_bundle" ->
            ( "a", "one-time hardware" )

        _ ->
            ( "a", "to-be-determined" )
