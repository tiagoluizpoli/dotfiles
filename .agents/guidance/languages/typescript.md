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

Project conventions override this profile.
