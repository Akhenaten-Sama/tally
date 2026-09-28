# Live lookup keys

Copy `keys.example.json` to `keys.json` and fill in the keys you have.
`keys.json` is git-ignored; never commit real keys.

| Key | Enables |
|---|---|
| `PAYSTACK_SECRET_KEY` | Real account-name lookup when sending money |
| `VTPASS_API_KEY`, `VTPASS_SECRET_KEY` | Real meter and smartcard verification |
| `VTPASS_SANDBOX` | `true` for VTpass sandbox (test numbers only), `false` for live |

Leave a key empty to keep that lookup simulated. Payments are always
simulated either way; these keys are only used for read-only lookups.

The keys are compiled into the app, so only install builds with real keys on
your own phone, and rotate the keys when you're done demoing.
