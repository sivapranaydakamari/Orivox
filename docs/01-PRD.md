# Product Requirements Document (PRD)

Project Name:
Enterprise Engineering Knowledge Assistant

Version:
1.0 (MVP)

Status:
Design Phase

Author:
Siva Pranay

---

# 1. Vision

Build an AI-powered Engineering Knowledge Assistant that continuously captures, organizes, secures, and retrieves engineering knowledge across software projects.

The platform should preserve engineering decisions, architectural reasoning, implementation knowledge, and API documentation so that knowledge remains accessible even when team members leave or teams evolve.

Instead of engineers manually searching through pull requests, documentation, or repositories, they should be able to ask natural language questions and receive evidence-based answers generated through Retrieval-Augmented Generation (RAG).

The platform is designed as an internal engineering product rather than a general-purpose chatbot.

---

# 2. Problem Statement

Engineering organizations lose valuable knowledge over time.

Typical problems include:

• Engineers leave the organization.

• Pull Requests explain implementation but become difficult to discover later.

• Documentation becomes outdated.

• API collections exist but are disconnected from engineering decisions.

• Important architectural decisions are buried inside reviews.

• New engineers require weeks to understand an existing project.

Most organizations already possess this knowledge.

The problem is that the knowledge is fragmented across multiple systems.

---

# 3. Goals

The MVP should solve the following problems.

## Primary Goals

• Automatically collect engineering knowledge.

• Normalize information into a common knowledge model.

• Generate semantic embeddings.

• Store knowledge securely.

• Allow engineers to ask questions using natural language.

• Return answers supported by retrieved evidence.

• Prevent access to unauthorized project information.

---

## Secondary Goals

• Reduce onboarding time.

• Preserve engineering reasoning.

• Improve documentation discoverability.

• Make project knowledge searchable.

---

# 4. Non Goals

The MVP will NOT include:

• Source code understanding.

• Automatic code generation.

• AI coding assistant.

• Bug fixing.

• CI/CD integration.

• Slack integration.

• Jira integration.

• Confluence integration.

• Multi-agent workflows.

• Fine-tuning LLMs.

These may be considered in future releases.

---

# 5. Target Users

## Platform Owner

Responsible for maintaining the platform.

Responsibilities

• Platform configuration

• Organization management

• System monitoring

---

## Organization Administrator

Responsible for a single organization.

Responsibilities

• Create projects

• Invite users

• Manage repositories

• Configure integrations

---

## Project Administrator

Responsible for a specific project.

Responsibilities

• Connect repositories

• Upload documentation

• Manage project members

• Review generated knowledge

---

## Engineers

Primary users.

Responsibilities

• Ask engineering questions

• Review generated knowledge

• Upload documentation

---

# 6. Functional Requirements

The system shall provide:

## Authentication

• Email Login

• JWT Authentication

• GitHub OAuth

---

## Organization Management

• Create organization

• Manage members

• Manage repositories

---

## Project Management

• Create project

• Assign members

• Connect repositories

---

## Knowledge Sources (MVP)

1. GitHub Pull Requests

2. Markdown Documentation

3. Postman Collections

4. Decision Logs

---

## Knowledge Pipeline

The system shall:

• Extract information

• Normalize content

• Generate summaries

• Create embeddings

• Store knowledge

---

## AI Search

Users can ask:

"Why are we using Kafka?"

The system should:

Retrieve relevant knowledge

↓

Build prompt

↓

Call LLM

↓

Generate answer

↓

Return supporting evidence

---

# 7. Non Functional Requirements

## Performance

Average AI response

< 5 seconds

---

## Scalability

Support

• Multiple organizations

• Multiple projects

• Multiple repositories

---

## Security

Project-level authorization

Organization isolation

JWT authentication

Role Based Access Control

---

## Reliability

No hallucinated answers.

Answers must be based on retrieved evidence.

---

# 8. MVP Scope

Included

✓ GitHub PR extraction

✓ Markdown ingestion

✓ Postman ingestion

✓ Manual Decision Logs

✓ MongoDB Atlas

✓ MongoDB Vector Search

✓ Mistral AI

✓ Custom RAG

✓ Flutter

✓ Node.js

Excluded

✗ Jira

✗ Slack

✗ Confluence

✗ Code Intelligence

✗ Local LLM

✗ Multi-Agent Systems

---

# 9. Success Metrics

The MVP will be considered successful if:

• Engineers receive relevant answers.

• Knowledge remains searchable.

• Project isolation works correctly.

• AI answers contain supporting evidence.

• Knowledge ingestion requires minimal manual effort.

---

# 10. Technology Stack

Frontend

Flutter

Backend

Node.js

Express.js

TypeScript

Database

MongoDB Atlas

Vector Search

MongoDB Atlas Vector Search

Authentication

JWT

GitHub OAuth

LLM

Mistral AI

Architecture

Custom RAG

Deployment

Docker

---

# 11. Future Roadmap

Phase 2

• Jira Integration

• Confluence Integration

• Slack Integration

• Incident Reports

Phase 3

• Repository Intelligence

• Architecture Graph

• Local LLM Support

• AI Agents

---

# 12. Design Principles

The following principles guide every engineering decision.

1. Project-based authorization.

2. Organization isolation.

3. AI never accesses databases directly.

4. Every knowledge source becomes a standardized Knowledge Record.

5. Retrieval always occurs before generation.

6. Evidence is mandatory for every AI answer.

7. The system should remain provider-agnostic.

8. Business logic should remain independent of the LLM provider.

9. The MVP should optimize for simplicity rather than scale.

10. Every future feature should integrate into the existing knowledge pipeline rather than bypass it.