module Survey.Graph exposing
    ( Choice
    , QuestionNode
    , questionGraph
    , rootNodeId
    )

import Dict exposing (Dict)
import Survey.Types exposing (Field(..))


{-| A choice's `id` doubles as the value written to its `field` (if any) —
e.g. selecting the "Web3 companies" choice (id "web3") under `SubTarget`
stores `subTarget = Just "web3"`. `next = Nothing` means this choice ends the
question graph and moves on to the Review phase. `description` is shown as
smaller helper text under the choice's `label`, explaining what picking it
actually implies for the product — the goal is that nobody has to guess what
a label means or already know outside context (brand references, jargon) to
answer.
-}
type alias Choice =
    { id : String
    , label : String
    , description : String
    , next : Maybe String
    , field : Maybe Field
    }


type alias QuestionNode =
    { id : String
    , prompt : String
    , description : String
    , choices : List Choice
    }


rootNodeId : String
rootNodeId =
    "q1-target-type"


questionGraph : Dict String QuestionNode
questionGraph =
    [ q1TargetType
    , q2bB2bSubtarget
    , q3bNixStatus
    , q4bWhyPay
    , q5bAiCentrality
    , q6bPricingModel
    , q7bBrandArchetype
    , q2iIndividualSubtarget
    , q3iWhyPay
    , q4iOwnership
    , q4iFreeMonetization
    , q5iBrandArchetype
    ]
        |> List.map (\node -> ( node.id, node ))
        |> Dict.fromList


q1TargetType : QuestionNode
q1TargetType =
    { id = "q1-target-type"
    , prompt = "Who is the primary buyer you're imagining for this product?"
    , description = "This is the foundational fork. You can serve both businesses and individuals, but the product's whole feel — pricing, tone, design — has to make sense for whichever one you pick here."
    , choices =
        [ { id = "business"
          , label = "Business / organization"
          , description = "Buying decisions go through budget approval and necessity, not gut feeling — think dev teams, IT departments, or infrastructure leads."
          , next = Just "q2b-b2b-subtarget"
          , field = Just TargetType
          }
        , { id = "individual"
          , label = "Individual / personal user"
          , description = "Buying decisions are personal and often emotional — think home-lab hobbyists, privacy-focused families, or solo developers."
          , next = Just "q2i-individual-subtarget"
          , field = Just TargetType
          }
        ]
    }


q2bB2bSubtarget : QuestionNode
q2bB2bSubtarget =
    { id = "q2b-b2b-subtarget"
    , prompt = "Which kind of business would get the most value?"
    , description = "These businesses are all drawn to Nix for similar reasons (reproducibility, observability), but they have different day-to-day pain points."
    , choices =
        [ { id = "web3"
          , label = "Web3 companies (blockchain / decentralized infrastructure)"
          , description = "Teams building decentralized/blockchain systems, often with strict uptime and compliance needs."
          , next = Just "q3b-nix-status"
          , field = Just SubTarget
          }
        , { id = "robotics_fleets"
          , label = "Robotics fleet operators"
          , description = "Teams managing fleets of robots or physical devices that need consistent, reproducible deployments across many machines."
          , next = Just "q3b-nix-status"
          , field = Just SubTarget
          }
        , { id = "nix_cicd"
          , label = "Nix CI/CD-heavy businesses (build pipelines already running on Nix)"
          , description = "Teams already running CI/CD on Nix who are hitting its complexity, slowness, or resource-usage limits."
          , next = Just "q3b-nix-status"
          , field = Just SubTarget
          }
        ]
    }


q3bNixStatus : QuestionNode
q3bNixStatus =
    { id = "q3b-nix-status"
    , prompt = "Is this buyer already using Nix, or would this be their first time?"
    , description = "Nix has a reputation for being a great idea with a rough execution — that leaves room to win over people already frustrated with it, which is a different pitch than winning over someone brand new to it."
    , choices =
        [ { id = "already_on_nix"
          , label = "Already using Nix — frustrated with their current setup"
          , description = "A migration play: win them away from a setup they already have but don't love."
          , next = Just "q4b-why-pay"
          , field = Nothing
          }
        , { id = "new_to_nix"
          , label = "New to Nix — hasn't adopted it yet"
          , description = "A conversion play: you're selling Nix's benefits for the first time, learning curve included."
          , next = Just "q4b-why-pay"
          , field = Nothing
          }
        ]
    }


q4bWhyPay : QuestionNode
q4bWhyPay =
    { id = "q4b-why-pay"
    , prompt = "Why would this buyer actually pay?"
    , description = "Nix CI/CD is often slow, resource-hungry, and hard to approach for newcomers — the core pitch has to be built around solving one of these pains particularly well."
    , choices =
        [ { id = "cheapest"
          , label = "Cheapest"
          , description = "Wins on price alone, even if it's not the fastest or easiest option available."
          , next = Just "q5b-ai-centrality"
          , field = Just WhyPay
          }
        , { id = "fastest"
          , label = "Fastest / most efficient"
          , description = "Wins by solving Nix's notoriously slow, resource-heavy builds."
          , next = Just "q5b-ai-centrality"
          , field = Just WhyPay
          }
        , { id = "convenient"
          , label = "Most convenient"
          , description = "Wins by abstracting away Nix's steep learning curve — the path of least friction is what makes it the easiest choice."
          , next = Just "q5b-ai-centrality"
          , field = Just WhyPay
          }
        , { id = "reliable"
          , label = "Most reliable"
          , description = "Wins because deployments and CI just work — no constant tinkering or firefighting once it's set up."
          , next = Just "q5b-ai-centrality"
          , field = Just WhyPay
          }
        ]
    }


q5bAiCentrality : QuestionNode
q5bAiCentrality =
    { id = "q5b-ai-centrality"
    , prompt = "How central should AI be to this product for this buyer?"
    , description = "This is its own decision, separate from pricing: if the promise is that AI will do the work, it has to actually deliver on that, or trust in the whole product breaks."
    , choices =
        [ { id = "ai_core"
          , label = "Core to the product — AI does the heavy lifting"
          , description = "The main pitch — developers barely touch Nix directly, AI handles it for them."
          , next = Just "q6b-pricing-model"
          , field = Just AiCentrality
          }
        , { id = "ai_supporting"
          , label = "A supporting feature — helpful, not the main value"
          , description = "A nice-to-have that smooths rough edges, but the product still works fine without leaning on it."
          , next = Just "q6b-pricing-model"
          , field = Just AiCentrality
          }
        , { id = "ai_not_central"
          , label = "Not central — this is about Nix/CI fundamentals"
          , description = "AI isn't part of the pitch at all — the value is Nix fundamentals done well."
          , next = Just "q6b-pricing-model"
          , field = Just AiCentrality
          }
        ]
    }


q6bPricingModel : QuestionNode
q6bPricingModel =
    { id = "q6b-pricing-model"
    , prompt = "Which business model fits this buyer?"
    , description = "The classic volume-vs-margin trade-off: a small number of big-spending customers, or a large number of small-spending ones."
    , choices =
        [ { id = "premium"
          , label = "Premium pricing — roughly 100 customers at ~$10k each"
          , description = "Fewer customers at a much higher price — needs a strong, differentiated pitch to justify the cost."
          , next = Just "q7b-brand-archetype"
          , field = Just PricingOrOwnership
          }
        , { id = "affordable"
          , label = "Affordable pricing — roughly 10,000 customers at ~$100 each"
          , description = "Many customers at a low price — needs low operating overhead to stay profitable at that price point."
          , next = Just "q7b-brand-archetype"
          , field = Just PricingOrOwnership
          }
        ]
    }


q7bBrandArchetype : QuestionNode
q7bBrandArchetype =
    { id = "q7b-brand-archetype"
    , prompt = "Which brand feel fits this buyer?"
    , description = "How the product should feel to a buyer evaluating it — this shapes marketing, design, and tone as much as the feature list does."
    , choices =
        [ { id = "premium_cutting_edge"
          , label = "Premium & cutting-edge — exclusive, top-tier, sets the standard"
          , description = "Positions the product as worth paying extra for — best-in-class, not for everyone."
          , next = Nothing
          , field = Just BrandArchetype
          }
        , { id = "reliable_dependable"
          , label = "Reliable & dependable — trusted, consistent, no surprises"
          , description = "Positions the product as the steady, no-drama choice — not flashy, just dependable."
          , next = Nothing
          , field = Just BrandArchetype
          }
        , { id = "invisible_convenience"
          , label = "Invisible, out-of-sight convenience — works quietly in the background"
          , description = "Positions the product as something you set up once and forget — out of sight, out of mind."
          , next = Nothing
          , field = Just BrandArchetype
          }
        ]
    }


q2iIndividualSubtarget : QuestionNode
q2iIndividualSubtarget =
    { id = "q2i-individual-subtarget"
    , prompt = "Which kind of individual user fits best?"
    , description = "Individuals buying this come from fairly different worlds — a home-lab tinkerer wants different things than someone just hosting a quick AI-built app."
    , choices =
        [ { id = "home_lab"
          , label = "Home-lab enthusiast"
          , description = "Wants a private, reliable home network — cares about reproducibility, has some technical background."
          , next = Just "q3i-why-pay"
          , field = Just SubTarget
          }
        , { id = "home_security"
          , label = "Home-security-focused"
          , description = "Wants peace of mind about their family's safety and data — security is the emotional hook."
          , next = Just "q3i-why-pay"
          , field = Just SubTarget
          }
        , { id = "personal_ai"
          , label = "Personal-AI user"
          , description = "Wants a personal AI assistant running on their own hardware, not a cloud subscription."
          , next = Just "q3i-why-pay"
          , field = Just SubTarget
          }
        , { id = "vibe_coded_hosting"
          , label = "Hosting apps built quickly with AI coding tools (sometimes called \"vibe coding\")"
          , description = "Wants somewhere to run apps they built quickly with AI tools — doesn't care about the infrastructure underneath."
          , next = Just "q3i-why-pay"
          , field = Just SubTarget
          }
        ]
    }


q3iWhyPay : QuestionNode
q3iWhyPay =
    { id = "q3i-why-pay"
    , prompt = "Why would this person actually pay?"
    , description = "Individuals weigh cost very differently than businesses — many will go to great lengths to avoid paying anything at all."
    , choices =
        [ { id = "cheapest"
          , label = "Cheapest"
          , description = "Wins purely on being the lowest-cost option available."
          , next = Just "q4i-ownership"
          , field = Just WhyPay
          }
        , { id = "fastest"
          , label = "Fastest"
          , description = "Wins by being quick to get up and running."
          , next = Just "q4i-ownership"
          , field = Just WhyPay
          }
        , { id = "convenient"
          , label = "Most convenient"
          , description = "Wins by being the easiest, lowest-friction option — set up over a weekend, then forget about it."
          , next = Just "q4i-ownership"
          , field = Just WhyPay
          }
        , { id = "reliable"
          , label = "Most reliable"
          , description = "Wins on dependability — it just keeps working, no constant tinkering or babysitting required."
          , next = Just "q4i-ownership"
          , field = Just WhyPay
          }
        ]
    }


q4iOwnership : QuestionNode
q4iOwnership =
    { id = "q4i-ownership"
    , prompt = "How would this person want to pay (or not pay) for it?"
    , description = "Beyond the standard self-host-vs-managed split, there are two other models worth considering: a gentle donation nudge, and a hardware bundle."
    , choices =
        [ { id = "self_host_free"
          , label = "Self-host, free — I'll own and run the infrastructure myself"
          , description = "No monetization at all — fully free and self-run. Makes no revenue guarantees on its own."
          , next = Just "q4i-free-monetization"
          , field = Just PricingOrOwnership
          }
        , { id = "self_host_donation"
          , label = "Self-host, free — but I'd make an optional one-time donation at setup"
          , description = "Still free to run, but gently asks for a one-time contribution at install — a middle ground for open-source."
          , next = Just "q4i-free-monetization"
          , field = Just PricingOrOwnership
          }
        , { id = "pay_for_convenience"
          , label = "Pay monthly for a managed, hosted service"
          , description = "A recurring subscription for convenience — but the easiest option for an unhappy customer to walk away from."
          , next = Just "q5i-brand-archetype"
          , field = Just PricingOrOwnership
          }
        , { id = "hardware_bundle"
          , label = "Pay once for a ready-to-use device — hardware and software bundled"
          , description = "A one-time hardware purchase with the software built in — harder to sell than cloud, but stickier once bought."
          , next = Just "q5i-brand-archetype"
          , field = Just PricingOrOwnership
          }
        ]
    }


q4iFreeMonetization : QuestionNode
q4iFreeMonetization =
    { id = "q4i-free-monetization"
    , prompt = "If it's free for this person, how would the business behind it actually make money?"
    , description = "The doc flags this directly: free, self-hostable software makes no revenue guarantees on its own — if the answer is \"free,\" something else still has to pay the bills."
    , choices =
        [ { id = "donations_only"
          , label = "Donations only"
          , description = "Relies purely on user goodwill — the same optional contribution prompted at setup, nothing more structured than that."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "paid_support"
          , label = "Paid support or consulting"
          , description = "The software stays free; money comes from helping people set it up, troubleshoot it, or run it for them."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "freemium_upsell"
          , label = "Freemium — free core, paid premium features"
          , description = "The base product stays free; advanced features, integrations, or capacity are paywalled."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "business_tier_subsidizes"
          , label = "A business/enterprise tier subsidizes the free individual tier"
          , description = "The same core product is sold to businesses elsewhere, and that revenue funds keeping it free for individuals."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "hardware_sales"
          , label = "Hardware sold separately"
          , description = "The software is free, but revenue comes from selling the hardware it's designed to run on."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "grants_sponsorship"
          , label = "Grants or sponsorships"
          , description = "Funded by foundations, sponsors, or donors rather than by the people actually using it."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        , { id = "unsure"
          , label = "Not sure yet"
          , description = "Honest signal that this hasn't been figured out — worth flagging rather than guessing."
          , next = Just "q5i-brand-archetype"
          , field = Just FreeMonetization
          }
        ]
    }


q5iBrandArchetype : QuestionNode
q5iBrandArchetype =
    { id = "q5i-brand-archetype"
    , prompt = "Which brand feel fits this persona best?"
    , description = "Individual buyers respond to feeling and identity more than business logic does — the same way a brand like John Deere sells an identity, not just a tractor."
    , choices =
        [ { id = "nerd_hobbyist"
          , label = "Nerd / hobbyist — technical, DIY, build-it-yourself appeal"
          , description = "Appeals to the DIY, technical-tinkerer identity — pride in building it yourself."
          , next = Nothing
          , field = Just BrandArchetype
          }
        , { id = "protective_security"
          , label = "Protective / security-focused — keeps my family and data safe"
          , description = "Appeals to the instinct to protect family and data — makes the buyer feel like the responsible one."
          , next = Nothing
          , field = Just BrandArchetype
          }
        , { id = "affordable_practical"
          , label = "Affordable / practical — sensible, no-frills, good value"
          , description = "Appeals to sensible, no-nonsense value — good enough, doesn't cost much."
          , next = Nothing
          , field = Just BrandArchetype
          }
        , { id = "smart_home_entertainment"
          , label = "All-in-one smart home — entertainment and convenience, not just protection"
          , description = "Appeals beyond protection into convenience and fun — an AI-run smart home, not just a lock on the door."
          , next = Nothing
          , field = Just BrandArchetype
          }
        ]
    }
