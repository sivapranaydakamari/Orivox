import { z } from 'zod';
import { IExtractionResult } from '../models/ai-output.schema';

const ExtractionResultSchema = z.object({
  summary: z.string().min(1, 'Summary must not be empty'),
  technicalDecisions: z.array(z.string()),
  businessContext: z.string(),
  risks: z.array(z.string()),
  breakingChanges: z.array(z.string()),
  dependencies: z.array(z.string()),
  componentsAffected: z.array(z.string()),
  apisMentioned: z.array(z.string()),
  confidenceScore: z.number().min(0).max(1),
});

export class ResponseValidator {
  /**
   * Validates a raw JSON string from an LLM against a generic Zod schema.
   */
  static validateJsonResponse<T>(rawJsonStr: string, schema: z.ZodSchema<T>): T {
    let cleanJson = rawJsonStr.trim();
    
    // Extract JSON block if it's wrapped in markdown code blocks
    const jsonBlockRegex = /```(?:json)?\s*([\s\S]*?)\s*```/i;
    const match = cleanJson.match(jsonBlockRegex);
    if (match && match[1]) {
      cleanJson = match[1].trim();
    }

    let parsedJson: unknown;
    try {
      parsedJson = JSON.parse(cleanJson);
    } catch (error) {
      throw new Error(`Failed to parse LLM JSON response - ${(error as Error).message}`);
    }

    const validationResult = schema.safeParse(parsedJson);

    if (!validationResult.success) {
      const errorMessages = validationResult.error.issues
        .map((err: z.ZodIssue) => `${err.path.join('.')}: ${err.message}`)
        .join('; ');
      throw new Error(`Invalid JSON structure - ${errorMessages}`);
    }

    return validationResult.data;
  }

  /**
   * Validates a raw JSON string from an LLM against the explicit Zod schema.
   */
  validate(rawJsonStr: string): IExtractionResult {
    return ResponseValidator.validateJsonResponse(rawJsonStr, ExtractionResultSchema);
  }
}

export const responseValidator = new ResponseValidator();
