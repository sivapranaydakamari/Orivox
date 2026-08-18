import { IAnswerResponse } from '../models/answer-response.model';

export class AnswerValidator {
  /**
   * - Invalid format
   * - Missing evidence references
   */
  public validate(rawResponse: string, sourcesCount: number): IAnswerResponse {
     
    let parsed: any;
    
    try {
      parsed = JSON.parse(rawResponse);
    } catch (_error) {
      throw new Error('Invalid format: Response is not valid JSON.');
    }

    if (!parsed.answer || typeof parsed.answer !== 'string' || parsed.answer.trim() === '') {
      throw new Error('Empty answer: Response must contain a non-empty "answer" field.');
    }

    if (parsed.confidence === undefined || typeof parsed.confidence !== 'number') {
      throw new Error('Missing or invalid "confidence" field in response.');
    }

    if (!Array.isArray(parsed.citations)) {
      throw new Error('Invalid format: "citations" must be an array.');
    }

    // Check for hallucinated source numbers. We expect citations to be like "[Source 1]"
    if (sourcesCount > 0) {
      for (const citation of parsed.citations) {
        const sourceMatch = String(citation).match(/\[Source (\d+)\]/i);
        if (sourceMatch) {
          const sourceNum = parseInt(sourceMatch[1], 10);
          if (sourceNum < 1 || sourceNum > sourcesCount) {
             throw new Error(`Hallucinated field: Cited Source ${sourceNum} does not exist in evidence.`);
          }
        }
      }
    }

    return {
      answer: parsed.answer,
      citations: parsed.citations,
      confidence: parsed.confidence,
      sources: [], // This will be populated by AnswerGenerationService
      warnings: Array.isArray(parsed.warnings) ? parsed.warnings : [],
    };
  }
}
