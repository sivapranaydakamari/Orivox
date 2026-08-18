import { ISourceProvider } from '../interfaces/source-provider.interface';
import { DocumentSourceType } from '../../document/model/document.model';

export class SourceRegistry {
  private providers: Map<DocumentSourceType, ISourceProvider> = new Map();

  /**
   * Register a provider implementation for a specific source type.
   */
  registerProvider(sourceType: DocumentSourceType, provider: ISourceProvider): void {
    if (this.providers.has(sourceType)) {
      throw new Error(`Provider for source type ${sourceType} is already registered.`);
    }
    this.providers.set(sourceType, provider);
  }

  /**
   * Retrieve the provider implementation for a given source type.
   */
  getProvider(sourceType: DocumentSourceType): ISourceProvider {
    const provider = this.providers.get(sourceType);
    if (!provider) {
      throw new Error(`No provider registered for source type ${sourceType}.`);
    }
    return provider;
  }
}

// Export as a singleton instance for global access
export const sourceRegistry = new SourceRegistry();
