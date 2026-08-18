# AI Skills Specification

Project:
Enterprise Engineering Knowledge Assistant

Version:
1.0

Status:
Locked

Purpose:
This document defines every AI capability used inside the system.

The AI is not treated as a chatbot.

It is treated as a collection of specialized engineering skills.

Every AI interaction must invoke one skill.

Every skill has a well-defined responsibility.

---

# AI Principles

The AI follows these principles.

1.

Never answer without retrieved knowledge.

---

2.

Never invent engineering decisions.

---

3.

Always cite supporting Knowledge Records.

---

4.

Never bypass authorization.

---

5.

Every skill produces structured output.

---

6.

The LLM is stateless.

Business context is always provided by the backend.

---

# AI Pipeline

User Request

↓

Authentication

↓

Authorization

↓

Knowledge Storage Manager

↓

Retrieve Knowledge

↓

Prompt Builder

↓

AI Skill

↓

Validation

↓

Response

---

# Skill 1

Knowledge Record Creator

Purpose

Convert raw engineering artifacts into standardized Knowledge Records.

Used During

Knowledge Ingestion

Input

GitHub Pull Request

Markdown

Postman Collection

Decision Log

Prompt Strategy

The model receives

• Raw engineering artifact

• Source metadata

The model extracts

• Engineering summary

• Technical reasoning

• Affected components

• Risks

• Tags

• Confidence

Output

Knowledge Record

Validation

Summary must not exceed
300 words.

Reasoning must explain

WHY

not only

WHAT.

Failure

Mark ingestion as failed.

Retry later.

---

# Skill 2

Engineering Question Answerer

Purpose

Answer engineering questions.

Used During

Chat

Input

User Question

+

Retrieved Knowledge

Prompt Strategy

Answer ONLY using
provided knowledge.

If evidence is insufficient,
state that clearly.

Never guess.

Output

Answer

Supporting Evidence

Confidence

Validation

Every answer
must reference at least
one Knowledge Record.

Failure

Return

Insufficient engineering evidence.

---

# Skill 3

Architecture Explainer

Purpose

Explain architectural decisions.

Example Questions

Why Kafka?

Why MongoDB?

Why Redis?

Why CQRS?

Input

Architecture Knowledge Records

Output

Decision

Reason

Tradeoffs

Alternatives

Validation

Must compare

Current decision

vs

Alternative.

---

# Skill 4

API Documentation Explainer

Purpose

Explain APIs
from Postman collections.

Input

API Knowledge Records

Output

Purpose

Authentication

Headers

Request

Response

Example

Validation

Every endpoint

must include

HTTP Method

URL

Purpose

---

# Skill 5

Repository Overview Generator

Purpose

Generate a project overview.

Input

Multiple Knowledge Records

Output

Project Summary

Architecture

Main Components

Dependencies

Important Decisions

Validation

Overview should focus on

engineering understanding

instead of documentation style.

---

# Skill 6

Change Impact Analyzer

Purpose

Estimate engineering impact.

Example

Engineer asks

What happens
if RabbitMQ
is removed?

Input

Question

+

Retrieved Knowledge

Output

Affected Components

Possible Risks

Dependencies

Confidence

Validation

The model should identify

unknown areas

instead of assuming.

---

# Skill 7

Knowledge Gap Detector

Purpose

Detect missing knowledge.

Example

Question

↓

No retrieval

↓

AI identifies

knowledge gap.

Output

Missing Information

Suggested Documents

Suggested Repository

Validation

Never fabricate.

---

# Prompt Builder

Every prompt follows
the same structure.

Section 1

System Rules

↓

Section 2

Retrieved Knowledge

↓

Section 3

User Question

↓

Section 4

Expected Response Format

Prompt builders
must never contain
business logic.

---

# System Prompt Rules

The AI is an engineering assistant.

It must

Answer only using retrieved knowledge.

Never invent information.

Explain uncertainty.

Respect project isolation.

Never mention hidden knowledge.

Never expose another project's information.

---

# Response Format

Every answer contains

Summary

↓

Detailed Explanation

↓

Supporting Evidence

↓

Confidence

↓

Suggested Related Topics

---

# Confidence Levels

High

Evidence from multiple records.

Medium

Evidence from one record.

Low

Incomplete knowledge.

None

No evidence.

---

# Validation Rules

The backend validates

Knowledge Retrieved

↓

Response Generated

↓

Evidence Exists

↓

Confidence Assigned

↓

Response Returned

If validation fails,

the response is discarded.

---

# Failure Handling

LLM Timeout

Retry.

No Knowledge

Return

"I couldn't find enough engineering evidence."

Authorization Failure

Return HTTP 403.

Embedding Failure

Retry ingestion.

Prompt Failure

Log incident.

---

# Future Skills

The architecture allows
additional skills
without changing
existing ones.

Examples

Incident Report Analyzer

Architecture Graph Builder

Deployment Guide Generator

Runbook Assistant

Code Review Assistant

Repository Health Analyzer

ADR Generator

Security Review Assistant

These should implement
the same skill interface.

---

# AI Skill Interface

Every AI capability should implement

Name

Purpose

Input

Prompt Strategy

Expected Output

Validation Rules

Failure Behavior

This guarantees
consistent AI behavior
across the platform.

---

# Final Principle

The AI is NOT the source of truth.

The Knowledge Records are.

The AI exists only to interpret,
organize and communicate
retrieved engineering knowledge.

If knowledge does not exist,

the correct answer is

"I don't know based on the available engineering evidence."

This principle must never be violated.