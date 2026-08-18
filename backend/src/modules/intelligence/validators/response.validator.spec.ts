import { describe, it, expect } from 'vitest';
import { ResponseValidator } from './response.validator';
import { z } from 'zod';

describe('ResponseValidator', () => {
  const schema = z.object({
    name: z.string(),
    age: z.number(),
  });

  it('should correctly parse valid JSON', () => {
    const validJson = `{"name": "Alice", "age": 30}`;
    const result = ResponseValidator.validateJsonResponse(validJson, schema);
    expect(result).toEqual({ name: 'Alice', age: 30 });
  });

  it('should clean markdown formatting from LLM response before parsing', () => {
    const markdownJson = `
      Here is the result you asked for:
      \`\`\`json
      {
        "name": "Bob",
        "age": 25
      }
      \`\`\`
    `;
    const result = ResponseValidator.validateJsonResponse(markdownJson, schema);
    expect(result).toEqual({ name: 'Bob', age: 25 });
  });

  it('should throw an error for invalid JSON', () => {
    const invalidJson = `{ name: "Charlie" }`; // Missing quotes
    expect(() => ResponseValidator.validateJsonResponse(invalidJson, schema)).toThrow(/Failed to parse LLM JSON response/);
  });

  it('should throw an error if JSON fails Zod schema validation', () => {
    const wrongSchemaJson = `{"name": "Alice", "age": "thirty"}`;
    expect(() => ResponseValidator.validateJsonResponse(wrongSchemaJson, schema)).toThrow(/Invalid JSON structure/);
  });
});
