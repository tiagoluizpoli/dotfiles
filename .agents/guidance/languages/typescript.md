# TypeScript

Use this profile for TypeScript source, configuration, and review. It is
independent of frontend and backend profiles.

- Preserve strict checking; model states and public contracts with explicit
  types, discriminated unions, and narrow interfaces.
- Keep `unknown` at untrusted boundaries and validate or narrow it before use.
- Keep runtime validation separate from static typing; a TypeScript type alone
  does not validate external data.
- Avoid `any`; model the real shape or narrow an unknown value.
- Let the compiler and project tooling prove the modified contract.

## Readability (code is reviewed by a human)

- Destructure deep values before use: read `const { maxAttempts } =
  config.verificationCode;` once at the top, then use the short name. Keep
  long `a.b.c` paths out of conditions, arithmetic and call arguments.
  Destructure instead of reassigning a property to a local
  (`const { commandPalette: paletteEnabled } = config.parked;`, not
  `const paletteEnabled = config.parked.commandPalette;`).
- Read fixed values once: when several methods of a class need the same
  injected value, read it in the constructor into a named `private readonly`
  field instead of destructuring it again in each method.
- Name nested call results: do not call a function inside another call's
  arguments; assign the inner result to a named `const` first.
- No unnamed numbers in logic: give each one a named `const` that states its
  intent (`CANCEL_BORDER_MARGIN_DAYS = 2`). A comment may add context but
  never replaces the name. Plain `0`/`1` counters and obvious test data are
  exempt.
- When the formatter breaks one expression over several lines, prefer
  extracting a named value over accepting the wrap.

Project conventions override this profile.
