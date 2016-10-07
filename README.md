Kyklo Test
==========

Kyklo [code exercise](exercise.pdf). Notes:

- Uses sqlite for simplicity.
- Uses a many-to-many relationship between organizations and models, which makes
  more sense to me. This requires an API change; specifically, requests have to
  be namespaced with the organization name, as in `/:organization/...`.
- Uses token-based auth. In a real application we would use real user-specific
  tokens, but here we just use accept the string `kyklo` for simplicity.
- Does not do any cacheing of requests to reuters, github etc. In a real
  application these requests should not be made synchronously during the
  request-response cycle. They should be handled in a background task, using
  Active Job or similar.
