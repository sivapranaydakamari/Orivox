# Architecture Document

Project: Enterprise Engineering Knowledge Assistant
Version: 1.0
Status:Architecture Locked

---

# 1. Purpose

This document describes the complete system architecture of the Engineering Knowledge Assistant.

The architecture has been designed with the following priorities:

- Security
- Simplicity
- Extensibility
- Provider Independence
- Evidence-based AI
- Project Isolation

The system follows a Retrieval-Augmented Generation (RAG) architecture where Large Language Models never directly access organizational data.

Instead, every response is generated only after retrieving authorized engineering knowledge.

---

# 2. High Level Architecture

                           Flutter Application
                                   │
                                   │ HTTPS + JWT
                                   ▼
                    ┌─────────────────────────┐
                    │ Express.js REST API     │
                    └───────────┬─────────────┘
                                │
          ┌─────────────────────┼──────────────────────┐
          │                     │                      │
          ▼                     ▼                      ▼
 Authentication         Project Services        AI Services
          │                     │                      │
          └──────────────┬──────┴──────────────┬───────┘
                         ▼                     ▼
               Knowledge Extraction    Knowledge Storage Manager
                         │                     │
                         ▼                     ▼
                Knowledge Pipeline      RAG Pipeline
                         │                     │
                         └────────────┬────────┘
                                      ▼
                                 MongoDB Atlas
                      (Knowledge + Vector Search)

---

# 3. Technology Stack

Frontend

Flutter

Purpose

Cross-platform mobile application.

---

Backend

Node.js

Express.js

TypeScript

Purpose

REST APIs

Authentication

Knowledge Pipeline

RAG Pipeline

---

Database

MongoDB Atlas

Purpose

Stores:

• Users

• Organizations

• Projects

• Knowledge Records

• Embeddings

• Audit Logs

MongoDB Atlas Vector Search is used instead of a dedicated vector database.

---

LLM

Mistral AI

Purpose

Summarization

Knowledge Creation

Question Answering

Reasoning

---

Authentication

JWT

GitHub OAuth

Purpose

Secure access

Repository connection

---

Deployment

Docker

Purpose

Portable deployment.

---

# 4. Core Components

The system consists of six primary components.

1.

Authentication Service

2.

Knowledge Extraction Service

3.

Knowledge Creation Service

4.

Knowledge Storage Manager

5.

RAG Service

6.

LLM Gateway

---

# 5. Authentication Service

Responsibilities

Authenticate users.

Issue JWT tokens.

Validate permissions.

Resolve accessible projects.

The JWT should contain:

User ID

Organization ID

Accessible Project IDs

Role

The backend should never trust frontend authorization.

Every request must validate permissions.

---

# 6. Project Based Security

The platform does NOT use manager hierarchy for permissions.

Instead

Organization

↓

Projects

↓

Members

Example

Amazon

├── Checkout

├── Payment

├── Notification

User

John

Projects

Checkout

Notification

John cannot retrieve knowledge from Payment.

Project isolation is mandatory.

---

# 7. Knowledge Sources

MVP supports four sources.

GitHub Pull Requests

Markdown Documentation

Postman Collections

Decision Logs

Every source enters the same pipeline.

No source bypasses the pipeline.

---

# 8. Knowledge Extraction Pipeline

GitHub

↓

Webhook

↓

Extraction Worker

↓

Raw Data

Markdown

↓

Parser

↓

Raw Data

Postman

↓

Collection Parser

↓

Raw Data

Decision Logs

↓

Upload

↓

Raw Data

Every extractor outputs raw structured data.

No AI processing occurs during extraction.

---

# 9. Knowledge Normalization

Different sources have different structures.

GitHub

↓

PR

Markdown

↓

Text

Postman

↓

Endpoints

Decision Logs

↓

Notes

↓

Knowledge Normalizer

↓

Knowledge Record

This is the most important architectural decision.

Every downstream component understands only one model:

Knowledge Record.

---

# 10. Knowledge Record

The Knowledge Record is the canonical representation of engineering knowledge.

Fields

organizationId

projectId

sourceType

title

summary

engineeringReasoning

affectedComponents

author

createdAt

tags

confidence

embedding

Every source must become this format before storage.

---

# 11. Knowledge Creation Service

Purpose

Convert raw engineering artifacts into structured knowledge.

Input

Raw GitHub Data

↓

Prompt Builder

↓

Mistral AI

↓

Knowledge Record

Outputs

Summary

Engineering Reasoning

Affected Components

Tags

Confidence Score

No embeddings are generated yet.

---

# 12. Embedding Pipeline

Knowledge Record

↓

Embedding Generator

↓

Vector

↓

MongoDB Atlas

The embedding represents semantic meaning.

Only finalized Knowledge Records are embedded.

---

# 13. MongoDB Design

Collections

organizations

users

projects

repositories

knowledge_records

documents

audit_logs

Knowledge Record contains

Structured Fields

+

Embedding Vector

This removes the need for ChromaDB.

---

# 14. Knowledge Storage Manager

Purpose

Acts as the secure gateway between AI and organizational knowledge.

Responsibilities

Resolve user permissions.

Select organization.

Filter projects.

Generate query embeddings.

Perform vector search.

Retrieve knowledge.

Build AI context.

Return context.

No LLM may access MongoDB directly.

Every retrieval must pass through this service.

---

# 15. RAG Pipeline

Engineer

↓

Question

↓

JWT Validation

↓

Permission Check

↓

Knowledge Storage Manager

↓

Generate Query Embedding

↓

MongoDB Vector Search

↓

Top K Knowledge Records

↓

Prompt Builder

↓

Mistral AI

↓

Evidence Based Response

↓

Flutter

Generation never occurs before retrieval.

---

# 16. Prompt Builder

The Prompt Builder combines

System Prompt

Retrieved Knowledge

User Question

The LLM never receives the entire database.

Only retrieved context.

---

# 17. LLM Gateway

Purpose

Provide a provider-independent interface.

Current Provider

Mistral AI

Future Providers

OpenAI

Gemini

Claude

Local Models

Business logic never depends on a specific provider.

Only the gateway changes.

---

# 18. Flutter Architecture

Presentation Layer

↓

State Management

↓

Services

↓

REST Client

↓

Backend APIs

Flutter never communicates with MongoDB.

Flutter never communicates with Mistral.

All requests go through Express.js.

---

# 19. Sequence Diagram

GitHub PR Merged

↓

Webhook

↓

Extraction

↓

Normalization

↓

Knowledge Creation

↓

Embedding

↓

MongoDB Storage

↓

Ready for Search

Later

Engineer asks

↓

Authentication

↓

Authorization

↓

Vector Search

↓

Prompt Builder

↓

Mistral

↓

Answer

---

# 20. Error Handling

Extraction Failure
Retry extraction.
LLM Failure
Retry request.
Embedding Failure
Mark record as pending.
Authorization Failure
Return HTTP 403.
No Knowledge Found
Return
"I couldn't find enough engineering evidence to answer this question."

---

# 21. Scalability Strategy

The MVP is intentionally simple, but includes core distributed system safeguards:
- **Distributed Locking**: Prevents race conditions during GitHub Repository Sync by utilizing atomic `findOneAndUpdate` queries on MongoDB with automatic lock expiration.
- **Transactional Outbox Pattern**: Ensures Background Jobs (BullMQ) are only enqueued if the underlying MongoDB transaction successfully commits. A background processor continuously polls `OutboxEvents` for reliable message delivery.
- **Dead Letter Queue (DLQ)**: Tracks failed asynchronous tasks and permits manual recovery.
- **Idempotent Workers**: All workers use unique constraints and upserts to prevent duplicate embedding or knowledge creation on retries.

Future improvements may include:
Event queues (e.g. Kafka or AWS SQS instead of Redis/BullMQ)
Repository indexing
Code intelligence
Distributed AI services
These additions should integrate with existing components without changing the overall architecture.

---

# 22. Architectural Principles

1. Project isolation over organizational hierarchy.
2. Knowledge before AI.
3. Normalize before embedding.
4. Retrieve before generation.
5. Evidence over hallucination.
6. One canonical Knowledge Record.
7. MongoDB is the source of truth.
8. LLMs never access databases directly.
9. Provider-independent AI architecture.
10. Every future feature should integrate into the existing pipeline rather than creating parallel systems.
