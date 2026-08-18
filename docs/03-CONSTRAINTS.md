# Engineering Constraints & Architectural Decisions

Project:
Enterprise Engineering Knowledge Assistant

Version:
1.0

Status:
Locked for MVP

Purpose:
This document defines the engineering rules, architectural decisions,
technology constraints, and implementation principles that must be
followed throughout the project.

Any new feature must comply with this document.

---

# 1. Engineering Philosophy

This project is designed around one simple idea.

Engineering knowledge should become a first-class asset.

Instead of engineers searching through repositories,
documentation and pull requests,
the platform continuously captures engineering knowledge
and allows it to be retrieved securely using AI.

Every architectural decision should support this objective.

---

# 2. Core Principles

The following principles are non-negotiable.

## Principle 1

Knowledge First

Never design AI features before designing
how engineering knowledge will be collected,
stored and retrieved.

Knowledge is the product.

AI is only an interface.

---

## Principle 2

Retrieval Before Generation

Every AI response must follow

Retrieve

↓

Verify

↓

Generate

The LLM must never answer directly.

---

## Principle 3

One Knowledge Model

Every source

GitHub

Markdown

Postman

Decision Logs

must become

ONE

Knowledge Record.

No component may introduce its own
knowledge format.

---

## Principle 4

Project Isolation

Knowledge belongs to projects.

Projects belong to organizations.

Users only access projects
they are assigned to.

There are no exceptions.

---

## Principle 5

Evidence Over Confidence

The AI should answer only when
supporting knowledge exists.

If sufficient evidence is unavailable,

the system should respond

"I couldn't find enough engineering evidence
to answer this question."

Never hallucinate.

---

# 3. Technology Constraints

Frontend

Flutter

No React

No Angular

No Web Frontend in MVP

---

Backend

Node.js

Express.js

TypeScript

No Spring Boot

No Python Backend

Python may only be introduced later
for specialized AI processing.

---

Database

MongoDB Atlas

MongoDB Atlas Vector Search

No PostgreSQL

No MySQL

No ChromaDB

No Pinecone

No FAISS

MongoDB is the single source of truth.

---

LLM

Mistral AI

The backend must communicate
through an LLM Gateway.

Never couple business logic
to a specific provider.

Future providers

OpenAI

Claude

Gemini

Local LLM

should be replaceable
without changing business logic.

---

Deployment

Docker

Docker Compose

Kubernetes is outside MVP scope.

---

# 4. Security Constraints

Security has higher priority
than AI accuracy.

Every request must satisfy

Authentication

↓

Authorization

↓

Knowledge Retrieval

↓

LLM

The LLM never receives
unauthorized knowledge.

---

JWT Tokens

Must contain

User ID

Organization ID

Project IDs

Role

Never trust frontend permissions.

---

Organization Isolation

Every database query

must include

organizationId.

No cross-organization search
is allowed.

---

Project Isolation

Every knowledge retrieval
must include

projectId

filtering.

No project may retrieve
another project's knowledge.

---

# 5. AI Constraints

The AI has no memory
of company knowledge.

The AI only knows
what the RAG pipeline retrieves.

---

The AI must never

Generate SQL

Execute Code

Access Databases

Access APIs

Access GitHub

without backend approval.

---

Prompt Builder

must provide

System Prompt

Retrieved Knowledge

User Question

Nothing else.

---

The prompt should never include

entire repositories

complete documentation

large markdown files

raw pull requests

Only relevant knowledge records.

---

# 6. Knowledge Constraints

Knowledge Sources

GitHub Pull Requests

Markdown Documentation

Postman Collections

Decision Logs

Only these four
exist in MVP.

---

Every source

must pass through

Extraction

↓

Normalization

↓

Knowledge Creation

↓

Embedding

↓

Storage

No shortcuts.

---

Knowledge Record

is immutable.

If information changes,

create a new version.

Never overwrite
historical engineering decisions.

---

# 7. Knowledge Storage Constraints

MongoDB is the only database.

Collections

organizations

users

projects

repositories

knowledge_records

documents

audit_logs

Embeddings are stored
inside Knowledge Records.

No duplicated vector storage.

---

Every Knowledge Record

must contain

Organization

Project

Source

Summary

Engineering Reasoning

Metadata

Embedding

Confidence

Timestamp

---

# 8. Knowledge Retrieval Constraints

All retrieval

must pass through

Knowledge Storage Manager.

The LLM never queries MongoDB.

The frontend never queries MongoDB.

Only

Knowledge Storage Manager

can access vector search.

---

Vector Search

must always filter

Organization

↓

Project

↓

Top-K Similarity

before returning knowledge.

---

Top K

Default

5

Maximum

10

Never send hundreds of records
to the LLM.

---

# 9. API Constraints

REST APIs only.

No GraphQL.

API Versioning

/api/v1/

Controllers

must never

contain business logic.

Controllers

↓

Services

↓

Repositories

↓

MongoDB

Architecture must remain layered.

---

# 10. Folder Structure Constraints

Business logic

must remain inside

services.

Database logic

must remain inside

repositories.

AI prompts

must remain inside

ai/

No prompt strings

inside controllers.

---

# 11. Logging Constraints

Every important event

must generate
an audit log.

Repository Connected

Knowledge Created

Knowledge Updated

User Login

Failed Authorization

Vector Search

LLM Request

LLM Failure

Audit logs
must never contain
sensitive information.

---

# 12. Error Handling Constraints

Extraction Failure

Retry.

Embedding Failure

Retry.

LLM Failure

Retry.

Authorization Failure

Return HTTP 403.

Validation Failure

Return HTTP 400.

Unknown Errors

Return HTTP 500.

Never expose stack traces
to the frontend.

---

# 13. Scalability Constraints

The MVP prioritizes

simplicity

over

distributed systems.

Therefore

No Kafka

No RabbitMQ

No Kubernetes

No Microservices

Everything runs
as one backend application.

Future scaling
must not require
rewriting business logic.

---

# 14. Future Expansion Rules

Future integrations

Jira

Confluence

Slack

Azure DevOps

must implement

Extractor

↓

Normalizer

↓

Knowledge Record

They must never bypass
the knowledge pipeline.

---

Future AI providers

must implement

LLM Gateway Interface.

Business logic

must remain unchanged.

---

# 15. Definition of Done

A feature is complete only if

✓ Authentication works

✓ Authorization works

✓ Validation works

✓ Audit logging exists

✓ Errors handled

✓ Tests written

✓ Documentation updated

✓ Constraints remain satisfied

---

# 16. Architectural Decisions (Locked)

Decision 1
Use Node.js + Express.js + TypeScript.
Reason
Excellent for API orchestration and asynchronous integrations.

---

Decision 2
Use Flutter.
Reason
Single cross-platform client and aligns with existing expertise.

---

Decision 3
Use MongoDB Atlas with Vector Search.
Reason
One database for structured knowledge and semantic search.

---

Decision 4
Use Custom RAG.
Reason
Provides a deeper understanding of the retrieval pipeline and avoids unnecessary framework abstraction for the MVP.

---

Decision 5
Use Mistral AI through an LLM Gateway.
Reason
Keeps the architecture provider-agnostic.

---

Decision 6
Store embeddings inside the Knowledge Record.
Reason
Maintains a single source of truth and avoids synchronization issues.

---

Decision 7
Use Project-Based RBAC.
Reason
Permissions naturally align with engineering work and repositories.

---

Decision 8
Normalize every source into a Knowledge Record.
Reason
All downstream services operate on one consistent data model.

---

# 17. Final Rule

Whenever a future feature is proposed,
ask the following questions:

1. Does it improve engineering knowledge?
2. Does it integrate into the existing knowledge pipeline?
3. Does it preserve project isolation?
4. Does it increase complexity without increasing value?

If the answer to the fourth question is "Yes",
do not implement it.