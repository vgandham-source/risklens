# RiskLens — Dataset Info Sheet
### For Engineers

---

## What you're working with

**Source:** Lending Club historical loan data (peer-to-peer lending platform), publicly available and widely mirrored.

**Where to get it:** Kaggle — search "All Lending Club loan data" (`wordsforthewise/lending-club`). It contains two related files:
- Loans that were **funded** — includes borrower details and how each loan performed over time
- Loan applications that were **rejected** — a smaller, separate file

**License:** Publicly released for research/analysis use, widely mirrored under open licenses (e.g., CC0). Cite the source in your repo's README. Don't commit the raw files themselves to your repo — document how to download them instead.

---

## What you need to figure out

This is intentionally not a full data dictionary. Part of the exercise is exploring the data yourself and making (and documenting) your own decisions on:

- **Which fields actually matter** for the analytics views your project requires (grade, purpose, geography, borrower segment, loan term, home ownership, vintage, survival — refer back to your Project Charter's FR-5 for the exact list of required views).
- **What date range / sample size** you'll work with. The full history is large — think about what's enough to show meaningful trends without making your warehouse costs or local runtimes painful, and document whatever you land on.
- **How you'll structure Bronze** — what raw tables/files you land, and how.
- **What's missing from the raw data that you'll need to generate yourself.** Re-read your Project Charter's requirements carefully (particularly around SCD Type 2, late-arriving data, and the streaming extension) and think about whether a static historical dataset from 2007–2018 can satisfy those requirements on its own. If not, that's a design problem for you to solve — including what synthetic data or generator logic you'll need to build, and why.

---

## A few constraints, not solutions

- No real customer/PII data may be used or introduced.
- Whatever you build to fill gaps in the raw data should be part of your repo (as code/logic), not just a one-off local file you generated and discarded.
- Document your reasoning. Decisions here will be evaluated on whether they're sound and clearly explained — not on matching one "correct" answer.
