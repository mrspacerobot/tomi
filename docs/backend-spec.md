# Tomi Rust backend specification

Status: consolidated architecture, 17 October 2026. The Rust service is implemented in the separate `tomi-backend` repository. The app uses it for Supabase identity, profiles, options, fridge scans and lesson suggestions. Cook events, canonical server progress, library delivery, resume validation, ratings and leaderboards below are future contracts, not implemented endpoints. The cooking graph remains draft content for internal testing.

## Outcome and boundary

Tomi is a native iPhone client of one public Tomi API. A Rust backend owns application decisions and durable multi-device state. A private, read-only graph component supplies reviewed cooking relationships to that backend from an immutable, versioned JSON release bundle. The graph authoring repository, its Python checks, and its draft channel are not runtime dependencies of the iPhone app.

The phone renders the interface, captures input, decodes bundled lessons for offline cooking and keeps the cook log in SwiftData. Food knowledge and filtering live only on the server. The phone refuses an offer unless its `checked` diet matches and its `checked` avoid list covers the cook's latest restrictions; it applies only swaps already listed by the lesson. No ingredient table, safety snapshot or second food matcher lives on the phone. Cook-event upload and server progress reconciliation are follow-up work.

| Migration source | Rust backend replacement | What remains on the phone |
|---|---|---|
| `LessonLibrary` and bundled catalog, ingredients, equipment and lessons | Publish signed, versioned reviewed library and safety snapshots; withdraw revisions | Decode and cache reviewed lessons; bundle a small offline set; food knowledge stays on the server |
| TomiCore lesson matching, unlock filtering, ranking and adaptation | Choose eligible lessons from confirmed IDs, preferences, skill progress and equipment; apply only reviewed swaps and serving changes | Present candidates only after checking the server's `checked` restrictions cover the cook |
| On-device ingredient interpretation and ranking | Resolve confirmed labels to candidate graph/library IDs; rank eligible results | Capture observed labels, let the cook correct them and confirm exact items |
| `ProgressStore` profile and `SavedProfile` merge | Canonical user profile and preferences, with strict handling of conflicting restrictions | Cached profile and an edit outbox; never replace unreadable restrictions with permissive defaults |
| `CookLogRecord`, `GameStateRules` and `ProgressRules` | Canonical immutable cook events; compute XP, rank, streak and mastery from deduplicated events | Queue events offline with stable IDs; display versioned server summaries when available |
| `ActiveLessonRecord` and resume rules | Canonical lesson session and revision, with server-side resume eligibility | Keep the active reviewed lesson and step locally so cooking can finish offline |
| Planned anonymous ratings and usage service | Ratings and aggregate usage endpoints | Explicit rating action; no ingredient, photo or chat payload in telemetry |
| No leaderboard feature today | New opt-in leaderboard derived from validated cook events | Public alias and participation controls; never expose diet, pantry or equipment |

Existing saved field names and published IDs remain stable through migration. A backend copy is not permission to discard the local records before reconciliation is proven.

## Runtime components

Start with one deployable Rust Tomi service, with separate modules for the public API, identity, profiles, cooking decisions, library delivery, cook events, ratings and leaderboard projection. The graph reader can run in the same process behind an internal interface. Split it into a separate private service only when independent scaling, release cadence or isolation is measured to help. The iPhone talks only to the Tomi API.

The graph repository produces a JSON bundle and manifest containing schema version, source commit, content hash, review channel and counts, as proposed in its [serving plan](https://github.com/mrspacerobot/cooking-graph/blob/40e1b8f/docs/serving-plan.md). Rust validates the manifest and checksum, rejects unknown schema versions, and builds indexes once at startup. A process is ready only after loading a compatible artifact. Replicas pin one artifact version; rollback restores the prior pin. SQLite is not part of the first artifact format. The draft channel is for internal fixtures only and cannot be returned to a release app.

The service stores user data in a transactional database. Its data model needs:

| Entity | Required identity and behavior |
|---|---|
| User | Stable opaque user ID, authentication binding, creation/deletion state and future production consent version covering uploaded photos and metadata, raw confirmed or typed labels, ingredient IDs and restrictions; no public profile by default |
| Profile | Versioned preferences, diet and avoid IDs, cuisine choices, pantry, equipment, experience, units, servings, weekly goal and focus skill; conflicting restrictions merge toward the stricter result |
| Cook event | Client-generated stable event ID, user ID, lesson ID and revision, skill and level, completion outcome, quiz result, event time, goal at the time, calendar context (calendar identifier, IANA time zone, first weekday and minimum days in the first week), and server receipt time; identity is user ID plus event ID |
| Active lesson | User ID, lesson/revision, reviewed swaps, final ingredient IDs, current step and update version; reject stale or withdrawn lessons and changed restrictions |
| Rating | User ID, lesson/revision, rating and time; never modify the cook event or XP |
| Leaderboard enrollment | User ID, opt-in state and public alias; private restrictions are never projected |
| Leaderboard projection | Period, derived score, rank and calculation version; rebuildable from accepted cook events |

XP is never accepted from the client and never the source of truth. The backend computes it from cook events and versioned game rules. Identical payloads for one event ID count once. Conflicting payloads with the same user and event ID are retained for reconciliation and invalidate that logical event until resolved; no variant earns progress, and any previously derived credit is recomputed. Arrival order never chooses a winner. Test finished versus stopped-early variants in both upload orders. Progress queries supply explicit current calendar context with those same four fields, and the backend uses calendar arithmetic rather than its system time zone or fixed day lengths. An event for an unknown skill or level is retained without awarding mastery until a compatible catalog can judge it. Offline events reconcile without depending on arrival order. Identity uses Supabase Auth with native Sign in with Apple, requesting email only. Supabase stores Apple's shared or relay address; sending mail and owning a domain are not required. Account recovery and deletion still need follow-up design.

## Public API contract

All endpoints are versioned and use typed IDs, explicit schema versions and structured errors. Responses that contain cooking content carry library, safety and graph artifact versions, review tier and channel. Unknown IDs, missing facts, incompatible versions and withdrawn revisions produce refusal, not an empty restriction or a guessed substitution.

| Route group | Request and response responsibility |
|---|---|
| `GET /v1/options` | The server-owned lists and localized words used by onboarding and settings |
| `POST /v1/scans` | Fridge photo to candidate ingredients for the cook to confirm |
| `GET /v1/bootstrap` | Supported API/schema versions, current reviewed library and safety versions, minimum app version |
| `POST /v1/ingredients/resolve` | Confirmed text labels to exact, alias, ambiguous or unknown ID candidates with evidence; never silently choose an ambiguous ID |
| `POST /v1/lessons/suggest` | Confirmed ingredient IDs to a special and up to two alternatives, each a graph recipe: `recipeId`, the graph's unchanged `sourceRecipe`, a `safePlan` (ingredients, substitutions with ratio and caveat, omitted parts, missing ingredients, equipment), `skill`, `level`, `reason` and `checked`. The answer names `graphVersion` and `graphChannel`; it has no lesson id, revision or minutes (tomi-backend #17) |
| `GET /v1/library/{version}` | Reviewed lesson files or a compatible delta; withdrawal list and content hashes; safety facts remain on the server |
| `GET/PATCH /v1/profile` | Read and update versioned preferences; reject a write that would silently weaken a restriction |
| `POST /v1/cook-events` | Idempotent batch acceptance by stable event ID and per-event result; return a versioned progress summary |
| `GET /v1/progress` | Explicit calendar context in; XP, rank, streak, mastery and unlocks computed from accepted events and the applicable catalog out |
| `GET/PUT /v1/active-lesson` | Resume bookmark with revision and conflict handling; validate against current restrictions before returning it |
| `POST /v1/ratings` | Record a rating for a reviewed lesson revision |
| `PUT /v1/leaderboard/enrollment` | Authenticated, versioned opt-in/opt-out and public-alias mutation for the current user |
| `GET /v1/leaderboard` | Only enrolled public aliases and derived scores; no private profile fields |

The gateway may call the graph's recipe, stand-in and kitchen queries internally. The Python query results generate conformance vectors that Rust must reproduce for directionality, exclusions, context, ties and unknown safety. A graph match alone is not a Tomi lesson and cannot be shown until it maps to reviewed Tomi content and passes final checks.

Request IDs support retries; authentication identifies the user; authorization scopes every profile, event and bookmark to that user. The current proof of concept has no consent step and is limited to the owner's own testing. Before real cooks use it, the disclosure and recorded consent must cover photos and metadata, raw typed or confirmed labels sent for resolution, ingredient IDs and restrictions before upload; a client-supplied opt-in header alone is not proof of consent. Rate limits and bounded responses protect the service. Logs contain status, latency, versions and aggregate counters, never photos, voice, chat, ingredients, restrictions or raw request bodies.

## Food safety and content release

The backend filters every candidate against the cook's restrictions before ranking and again after a swap or serving adaptation changes ingredients. Ingredient facts come only from a reviewed safety snapshot. A model cannot add facts, ingredients, diets, avoid items, skills or equipment. A missing or unreadable fact fails closed. A recipe with an open safety point, unverified safety record or insufficient review tier cannot be published.

The phone verifies `checked` restrictions before presenting an offer, and refuses unreadable restrictions. A profile change that alters diet or avoid items clears the saved lesson bookmark. A future resume flow must ask the server to check the lesson again; there is no resume-check endpoint yet. The phone shows a graph offer's safe plan beside its source recipe and never calls the source recipe adapted; an offer it cannot read in full is left out. Cooking a graph recipe is not designed yet (#135), so no lesson is cooked from an offer for now. Photo recognition never judges doneness or food safety.

## Offline and media behavior

Offline means the cook can open a compatible downloaded lesson, follow steps, use timers and record completion. The app queues a cook event and uploads it with the same ID when connected. It need not generate a new personalized special offline. The UI makes pending progress distinct from server-confirmed progress and reconciles without double credit.

Fridge photos are sent to the backend as JPEGs up to 1280 pixels on the long side at quality 0.6, including their original place and time. The proof of concept keeps every scan when storage is configured, for the owner's own test photos only. Before real cooks use it, add an explicit consent flow, withdrawal and deletion, and a privacy review. Chat and voice stay on the phone; remote speech is undecided. The graph component never receives media.

## Migration and acceptance

1. Specify request/response fixtures and local acceptance tests. Cover unknown restrictions, ambiguous resolution, unsafe swaps, stale or draft content, changed preferences, duplicate events and offline replay.
2. Build the graph production gate and JSON artifact with conformance vectors. Today production must fail because graph review and safety verification are incomplete. Use synthetic fixtures and Tomi's reviewed lessons for development.
3. Build Rust bootstrap, library and typed-list-to-special APIs. Add a fake gateway client in Tomi and prove the UI flow end to end before switching its data source.
4. Deliver reviewed lesson files and withdrawal metadata. Keep food facts and safety checks on the server; retain the checked-offer guard on the phone. Prove online, cache, withdrawal and offline behavior before replacing the bundled lessons.
5. Add identity, profile and cook-event persistence. Import existing SwiftData records without deleting them; compare backend and TomiCore progress for the same log, then make the backend canonical after reconciliation passes.
6. Add active-lesson sync, ratings and opt-in leaderboards. Remote fridge scanning already exists for the proof of concept; require the production consent and deletion contract before real cooks use it. Remote chat and speech remain undecided.

Each slice is one issue and one pull request. Required checks include Rust unit and integration tests, Python-to-Rust conformance vectors, database migration and idempotency tests, TomiCore safety tests, and a fake-backed iOS UI test for each changed flow. Run `./scripts/check.sh` for Tomi changes. Measure startup index time, peak memory and p95/p99 latency on current and larger graph fixtures before capacity claims. The graph is not allowed into production until its review and safety gates pass.

## Decisions still open

- Consent, deletion and the provider contract before real cooks upload photos; whether voice may leave the phone.
- Account recovery and deletion, and whether iCloud remains a backup during migration. Sign-in is Supabase with Apple.
- Leaderboard product rules: opt-in, public alias, ranking period, eligibility and abuse handling.
- Offline retention period and how a withdrawn lesson is handled on a device that has not reconnected.

Rust and the versioned JSON graph artifact are chosen. These open product and data decisions do not block writing contracts or synthetic-fixture tests.
