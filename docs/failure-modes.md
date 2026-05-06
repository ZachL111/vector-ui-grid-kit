# Failure Modes

For `vector-ui-grid-kit`, I would look first for these mistakes:

- `view drift` cases moving lanes without a matching threshold change.
- `layout risk` scoring higher after drag increases.
- Duplicate fixture ids hiding a stale golden row.
- README examples drifting away from the verifier.

The local checks are intentionally strict about these cases.
