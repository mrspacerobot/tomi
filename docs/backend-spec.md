# Tomi Rust backend specification

Status: target architecture, 8 October 2026. This is a specification, not a claim that the service exists. The current iPhone app stores progress in SwiftData and computes most rules in TomiCore. The private cooking graph is a draft and cannot yet supply cook-facing content.

## Outcome and boundary

Tomi is a native iPhone client of one public Tomi API. A Rust backend owns application decisions and durable multi-device state. A private, read-only graph component supplies reviewed cooking relationships to that backend from an immutable, versioned JSON release bundle. The graph authoring repository, its Python checks, and its draft channel are not runtime dependencies of the iPhone app.

The phone still renders the interface, captures input, runs timers and voice playback, keeps a reviewed lesson available while cooking, queues offline cook events, and independently rejects food that conflicts with the cook's restrictions. This local check is deliberately small: it validates the final ingredient IDs and a compatible reviewed safety snapshot. It does not rank recipes or maintain a second graph matcher.

| Current Tomi owner | Rust backend replacement | What remains on the phone |
|---|---|---|
| `LessonLibrary` and bundled catalog, ingredients, equipment and lessons | Publish signed, versioned reviewed library and safety snapshots; withdraw revisions | Decode and cache compatible reviewed snapshots; bundle a small offline set |
| TomiCore lesson matching, unlock filtering, ranking and adaptation | Choose eligible lessons from confirmed IDs, preferences, skill progress and equipment; apply only reviewed swaps and serving changes | Present candidates after a final independent restriction check |
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
| User | Stable opaque user ID, authentication binding, creation/deletion state and recorded version of the consent to send confirmed ingredients and restrictions; no public profile by default |
| Profile | Versioned preferences, diet and avoid IDs, cuisine choices, pantry, equipment, experience, units, servings, weekly goal and focus skill; conflicting restrictions merge toward the stricter result |
| Cook event | Client-generated stable event ID, user ID, lesson ID and revision, skill and level, completion outcome, quiz result, event time, goal at the time and server receipt time; unique per user and event ID |
| Active lesson | User ID, lesson/revision, reviewed swaps, final ingredient IDs, current step and update version; reject stale or withdrawn lessons and changed restrictions |
| Rating | User ID, lesson/revision, rating and time; never modify the cook event or XP |
| Leaderboard enrollment | User ID, opt-in state and public alias; private restrictions are never projected |
| Leaderboard projection | Period, derived score, rank and calculation version; rebuildable from accepted cook events |

XP is never accepted from the client and never the source of truth. The backend computes it from cook events and versioned game rules. A repeated event ID has one effect. An event for an unknown skill or level is retained without awarding mastery until a compatible catalog can judge it. Offline events reconcile without depending on arrival order. Authentication and account recovery need a separate design before this database becomes canonical.

## Public API contract

All endpoints are versioned and use typed IDs, explicit schema versions and structured errors. Responses that contain cooking content carry library, safety and graph artifact versions, review tier and channel. Unknown IDs, missing facts, incompatible versions and withdrawn revisions produce refusal, not an empty restriction or a guessed substitution.

| Route group | Request and response responsibility |
|---|---|
| `GET /v1/bootstrap` | Supported API/schema versions, current reviewed library and safety versions, minimum app version |
| `POST /v1/ingredients/resolve` | Confirmed text labels to exact, alias, ambiguous or unknown ID candidates with evidence; never silently choose an ambiguous ID |
| `POST /v1/specials` | Confirmed ingredient IDs, restrictions, skill context and equipment to bounded reviewed lesson candidates, final ingredients, missing parts and explanations |
| `GET /v1/library/{version}` | Signed reviewed library and safety snapshot or a compatible delta; withdrawal list and content hashes |
| `GET/PATCH /v1/profile` | Read and update versioned preferences; reject a write that would silently weaken a restriction |
| `POST /v1/cook-events` | Idempotent batch acceptance by stable event ID and per-event result; return a versioned progress summary |
| `GET /v1/progress` | XP, rank, streak, mastery and unlocks computed from accepted events and the applicable catalog |
| `GET/PUT /v1/active-lesson` | Resume bookmark with revision and conflict handling; validate against current restrictions before returning it |
| `POST /v1/ratings` | Record a rating for a reviewed lesson revision |
| `GET /v1/leaderboard` | Only enrolled public aliases and derived scores; no private profile fields |

The gateway may call the graph's recipe, stand-in and kitchen queries internally. The Python query results generate conformance vectors that Rust must reproduce for directionality, exclusions, context, ties and unknown safety. A graph match alone is not a Tomi lesson and cannot be shown until it maps to reviewed Tomi content and passes final checks.

Request IDs support retries; authentication identifies the user; authorization scopes every profile, event and bookmark to that user. The app explains that a match sends confirmed ingredient IDs and restrictions and records the cook's choice before sending them; a client-supplied opt-in header alone is not proof of consent. Rate limits and bounded responses protect the service. Logs contain status, latency, versions and aggregate counters, never photos, voice, chat, ingredients, restrictions or raw request bodies.

## Food safety and content release

The backend filters every candidate against the cook's restrictions before ranking and again after a swap or serving adaptation changes ingredients. Ingredient facts come only from a reviewed safety snapshot. A model cannot add facts, ingredients, diets, avoid items, skills or equipment. A missing or unreadable fact fails closed. A recipe with an open safety point, unverified safety record or insufficient review tier cannot be published.

The phone independently checks the returned final ingredient IDs against the compatible reviewed safety snapshot and its latest known restrictions before display and again before resuming a cached lesson. If the snapshot is absent or incompatible, it does not show a diet or allergen suitability claim or a candidate special. A previously downloaded reviewed lesson may still be cooked offline if its revision and safety snapshot remain compatible with the current restrictions; otherwise the app asks to reconnect or choose a different reviewed lesson. Photo recognition never judges doneness or food safety.

## Offline and media behavior

Offline means the cook can open a compatible downloaded lesson, follow steps, use timers and record completion. The app queues a cook event and uploads it with the same ID when connected. It need not generate a new personalized special offline. The UI makes pending progress distinct from server-confirmed progress and reconciles without double credit.

Under the current project rule, photos, chat and voice stay on the phone. Observed photo labels may be produced locally, but the cook confirms items and exact IDs before matching. A separate remote vision or speech service is a possible future product decision, not part of this specification's authorized implementation. It would require an explicit change to `AGENTS.md`, the user flow and privacy review before any upload. The graph component never receives media.

## Migration and acceptance

1. Specify request/response fixtures and local acceptance tests. Cover unknown restrictions, ambiguous resolution, unsafe swaps, stale or draft content, changed preferences, duplicate events and offline replay.
2. Build the graph production gate and JSON artifact with conformance vectors. Today production must fail because graph review and safety verification are incomplete. Use synthetic fixtures and Tomi's reviewed lessons for development.
3. Build Rust bootstrap, library and typed-list-to-special APIs. Add a fake gateway client in Tomi and prove the UI flow end to end before switching its data source.
4. Deliver a signed reviewed library and safety snapshot. Prove online, cache, withdrawal and offline behavior. Keep the existing bundle until the new path is proven.
5. Add identity, profile and cook-event persistence. Import existing SwiftData records without deleting them; compare backend and TomiCore progress for the same log, then make the backend canonical after reconciliation passes.
6. Add active-lesson sync, ratings and opt-in leaderboards. Add a remote media path only after its separate decision and tests.

Each slice is one issue and one pull request. Required checks include Rust unit and integration tests, Python-to-Rust conformance vectors, database migration and idempotency tests, TomiCore safety tests, and a fake-backed iOS UI test for each changed flow. Run `./scripts/check.sh` for Tomi changes. Measure startup index time, peak memory and p95/p99 latency on current and larger graph fixtures before capacity claims. The graph is not allowed into production until its review and safety gates pass.

## Decisions still open

- Whether fridge photos or voice may ever leave the phone, and the exact consent and provider contract if so.
- User sign-in and account recovery method, and whether iCloud remains a backup during migration.
- Leaderboard product rules: opt-in, public alias, ranking period, eligibility and abuse handling.
- Offline retention period and how a withdrawn lesson is handled on a device that has not reconnected.

Rust and the versioned JSON graph artifact are chosen. These open product and data decisions do not block writing contracts or synthetic-fixture tests.
