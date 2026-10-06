# Product Direction Poll — Questions

This is the question content from the survey app (`src/Survey/Graph.elm`), abstracted out of the Elm code so it can be read, shared, and reviewed on its own. If the graph changes, re-sync this file by hand.

Every question lists its choices; the italic line under each choice is the helper text shown in the app explaining what picking it implies.

---

## 1. Who is the primary buyer you're imagining for this product?

This is the foundational fork. You can serve both businesses and individuals, but the product's whole feel — pricing, tone, design — has to make sense for whichever one you pick here.

- **Business / organization**
  *Buying decisions go through budget approval and necessity, not gut feeling — think dev teams, IT departments, or infrastructure leads.*
- **Individual / personal user**
  *Buying decisions are personal and often emotional — think home-lab hobbyists, privacy-focused families, or solo developers.*

---

## Business / organization path

### 2b. Which kind of business would get the most value?

These businesses are all drawn to Nix for similar reasons (reproducibility, observability), but they have different day-to-day pain points.

- **Web3 companies (blockchain / decentralized infrastructure)**
  *Teams building decentralized/blockchain systems, often with strict uptime and compliance needs.*
- **Robotics fleet operators**
  *Teams managing fleets of robots or physical devices that need consistent, reproducible deployments across many machines.*
- **Nix CI/CD-heavy businesses (build pipelines already running on Nix)**
  *Teams already running CI/CD on Nix who are hitting its complexity, slowness, or resource-usage limits.*

### 3b. Is this buyer already using Nix, or would this be their first time?

Nix has a reputation for being a great idea with a rough execution — that leaves room to win over people already frustrated with it, which is a different pitch than winning over someone brand new to it.

- **Already using Nix — frustrated with their current setup**
  *A migration play: win them away from a setup they already have but don't love.*
- **New to Nix — hasn't adopted it yet**
  *A conversion play: you're selling Nix's benefits for the first time, learning curve included.*

### 4b. Why would this buyer actually pay?

Nix CI/CD is often slow, resource-hungry, and hard to approach for newcomers — the core pitch has to be built around solving one of these pains particularly well.

- **Cheapest**
  *Wins on price alone, even if it's not the fastest or easiest option available.*
- **Fastest / most efficient**
  *Wins by solving Nix's notoriously slow, resource-heavy builds.*
- **Most convenient**
  *Wins by abstracting away Nix's steep learning curve — the path of least friction is what makes it the easiest choice.*
- **Most reliable**
  *Wins because deployments and CI just work — no constant tinkering or firefighting once it's set up.*

### 5b. How central should AI be to this product for this buyer?

This is its own decision, separate from pricing: if the promise is that AI will do the work, it has to actually deliver on that, or trust in the whole product breaks.

- **Core to the product — AI does the heavy lifting**
  *The main pitch — developers barely touch Nix directly, AI handles it for them.*
- **A supporting feature — helpful, not the main value**
  *A nice-to-have that smooths rough edges, but the product still works fine without leaning on it.*
- **Not central — this is about Nix/CI fundamentals**
  *AI isn't part of the pitch at all — the value is Nix fundamentals done well.*

### 6b. Which business model fits this buyer?

The classic volume-vs-margin trade-off: a small number of big-spending customers, or a large number of small-spending ones.

- **Premium pricing — roughly 100 customers at ~$10k each**
  *Fewer customers at a much higher price — needs a strong, differentiated pitch to justify the cost.*
- **Affordable pricing — roughly 10,000 customers at ~$100 each**
  *Many customers at a low price — needs low operating overhead to stay profitable at that price point.*

### 7b. Which brand feel fits this buyer? *(ends the business path → Review)*

How the product should feel to a buyer evaluating it — this shapes marketing, design, and tone as much as the feature list does.

- **Premium & cutting-edge — exclusive, top-tier, sets the standard**
  *Positions the product as worth paying extra for — best-in-class, not for everyone.*
- **Reliable & dependable — trusted, consistent, no surprises**
  *Positions the product as the steady, no-drama choice — not flashy, just dependable.*
- **Invisible, out-of-sight convenience — works quietly in the background**
  *Positions the product as something you set up once and forget — out of sight, out of mind.*

---

## Individual / personal user path

### 2i. Which kind of individual user fits best?

Individuals buying this come from fairly different worlds — a home-lab tinkerer wants different things than someone just hosting a quick AI-built app.

- **Home-lab enthusiast**
  *Wants a private, reliable home network — cares about reproducibility, has some technical background.*
- **Home-security-focused**
  *Wants peace of mind about their family's safety and data — security is the emotional hook.*
- **Personal-AI user**
  *Wants a personal AI assistant running on their own hardware, not a cloud subscription.*
- **Hosting apps built quickly with AI coding tools (sometimes called "vibe coding")**
  *Wants somewhere to run apps they built quickly with AI tools — doesn't care about the infrastructure underneath.*

### 3i. Why would this person actually pay?

Individuals weigh cost very differently than businesses — many will go to great lengths to avoid paying anything at all.

- **Cheapest**
  *Wins purely on being the lowest-cost option available.*
- **Fastest**
  *Wins by being quick to get up and running.*
- **Most convenient**
  *Wins by being the easiest, lowest-friction option — set up over a weekend, then forget about it.*
- **Most reliable**
  *Wins on dependability — it just keeps working, no constant tinkering or babysitting required.*

### 4i. How would this person want to pay (or not pay) for it?

Beyond the standard self-host-vs-managed split, there are two other models worth considering: a gentle donation nudge, and a hardware bundle.

- **Self-host, free — I'll own and run the infrastructure myself**
  *No monetization at all — fully free and self-run. Makes no revenue guarantees on its own.* → continues to 4i-free
- **Self-host, free — but I'd make an optional one-time donation at setup**
  *Still free to run, but gently asks for a one-time contribution at install — a middle ground for open-source.* → continues to 4i-free
- **Pay monthly for a managed, hosted service**
  *A recurring subscription for convenience — but the easiest option for an unhappy customer to walk away from.*
- **Pay once for a ready-to-use device — hardware and software bundled**
  *A one-time hardware purchase with the software built in — harder to sell than cloud, but stickier once bought.*

### 4i-free. If it's free for this person, how would the business behind it actually make money? *(only asked after picking one of the two free options above)*

The doc flags this directly: free, self-hostable software makes no revenue guarantees on its own — if the answer is "free," something else still has to pay the bills.

- **Donations only**
  *Relies purely on user goodwill — the same optional contribution prompted at setup, nothing more structured than that.*
- **Paid support or consulting**
  *The software stays free; money comes from helping people set it up, troubleshoot it, or run it for them.*
- **Freemium — free core, paid premium features**
  *The base product stays free; advanced features, integrations, or capacity are paywalled.*
- **A business/enterprise tier subsidizes the free individual tier**
  *The same core product is sold to businesses elsewhere, and that revenue funds keeping it free for individuals.*
- **Hardware sold separately**
  *The software is free, but revenue comes from selling the hardware it's designed to run on.*
- **Grants or sponsorships**
  *Funded by foundations, sponsors, or donors rather than by the people actually using it.*
- **Not sure yet**
  *Honest signal that this hasn't been figured out — worth flagging rather than guessing.*

### 5i. Which brand feel fits this persona best? *(ends the individual path → Review)*

Individual buyers respond to feeling and identity more than business logic does — the same way a brand like John Deere sells an identity, not just a tractor.

- **Nerd / hobbyist — technical, DIY, build-it-yourself appeal**
  *Appeals to the DIY, technical-tinkerer identity — pride in building it yourself.*
- **Protective / security-focused — keeps my family and data safe**
  *Appeals to the instinct to protect family and data — makes the buyer feel like the responsible one.*
- **Affordable / practical — sensible, no-frills, good value**
  *Appeals to sensible, no-nonsense value — good enough, doesn't cost much.*
- **All-in-one smart home — entertainment and convenience, not just protection**
  *Appeals beyond protection into convenience and fun — an AI-run smart home, not just a lock on the door.*

---

## Review

Both paths end here: a summary of every answer given, one optional free-text box ("Anything else you'd like to add?"), then Submit.
