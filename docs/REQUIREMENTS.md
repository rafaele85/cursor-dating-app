# Dating App – Requirements

## Overview
Full-stack dating app: Google sign-in, profile, photos, browse, swipe, matches, chat. Deploy to GCP.

## Features
- **Auth:** Sign up / sign in with Google only (no email/password).
- **Profile:** Create and edit profile (name, bio, age, gender, who to see).
- **Photos:** Upload, reorder, delete; one primary photo.
- **Browse:** See others that match preferences; exclude already swiped.
- **Swipe:** Like (right) / dislike (left); record and don’t show again.
- **Matches:** Mutual like = match; list matches, view their profile.
- **Chat:** Text chat only with matches (conversations + messages).

## Tech Stack
- Frontend: React, TypeScript.
- Backend: Fastify, TypeScript.
- Database: Cloud SQL via Prisma.
- Deploy: GCP.

## Process & Quality
- KISS, YAGNI. Tiny increments. Gitflow with human PR review.
- Flow: requirements → plan → tickets → code → tests → PR → deploy.
- Gates: Biome, type check, unit tests, e2e tests.
