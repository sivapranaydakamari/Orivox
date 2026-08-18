export class EmbeddingValidator {
  /**
   * Validates the generated embedding vector.
   * Ensures it is not empty, matches expected dimensions, and contains no NaN values.
   */
  validate(vector: number[], expectedDimensions = 1024): void {
    if (!vector || vector.length === 0) {
      throw new Error('EmbeddingValidator: Vector is empty or undefined.');
    }

    if (vector.length !== expectedDimensions) {
      throw new Error(`EmbeddingValidator: Vector dimension mismatch. Expected ${expectedDimensions}, got ${vector.length}.`);
    }

    const hasNaN = vector.some((val) => Number.isNaN(val));
    if (hasNaN) {
      throw new Error('EmbeddingValidator: Vector contains NaN values.');
    }
  }
}

export const embeddingValidator = new EmbeddingValidator();
