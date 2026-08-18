import { IParsedDocument } from '../models/parsed-document.model';

export class PromptBuilderService {
  /**
   * Constructs the System Prompt explicitly dictating JSON structure constraints.
   */
  buildSystemPrompt(): string {
    return `You are an expert Enterprise Engineering Knowledge extractor.
Your task is to analyze raw engineering artifacts (like GitHub Pull Requests or Design Docs) and extract structured knowledge.

You MUST format your output strictly as a JSON object adhering to the following schema:
{
  "summary": "String detailing the core purpose.",
  "technicalDecisions": ["Array of specific architectural or code-level choices made"],
  "businessContext": "String explaining WHY this was built",
  "risks": ["Array of potential issues, security flaws, or technical debt"],
  "breakingChanges": ["Array of breaking API or database changes"],
  "dependencies": ["Array of added/modified external libraries or internal systems"],
  "componentsAffected": ["Array of files, modules, or microservices changed"],
  "apisMentioned": ["Array of internal or external API endpoints referenced"],
  "confidenceScore": "Number between 0 and 1 indicating certainty in extraction"
}

Do NOT output anything outside of this JSON block.`;
  }

  /**
   * Constructs the User Prompt mapping the ParsedDocument variables cleanly for the LLM.
   */
  buildUserPrompt(document: IParsedDocument): string {
    return `Please extract the knowledge from the following engineering artifact.

TITLE: ${document.title}
AUTHOR: ${document.author}
SOURCE TYPE: ${document.sourceType}

--- ARTIFACT CONTENT ---
${document.content}
------------------------

Analyze the artifact and return the strictly formatted JSON response.`;
  }
}

export const promptBuilder = new PromptBuilderService();
