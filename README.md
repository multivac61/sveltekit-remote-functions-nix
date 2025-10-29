# SvelteKit Remote Functions

This is a SvelteKit CRUD app example using:

- [Remote functions](https://svelte.dev/docs/kit/remote-functions) for type-safe communication between client and server
- [Better Auth](https://www.better-auth.com/) for authentication
- [Drizzle ORM](https://orm.drizzle.team/) for working with the SQLite database
- [Pico CSS](https://picocss.com/) for styling
- [Prettier](https://prettier.io/) for code formatting
- [Nix](https://nix.dev/) for dev shell, deterministic build system and checks

## Setup

### ✏️ Rename .env.example

```sh
mv .env.example .env
```

### 📦️ Install dependencies

```sh
pnpm i
```

### Create tables from Drizzle schema

```sh
pnpm run db:push
```

### 🧑‍💻 Start the development server

```sh
pnpm run dev
```
