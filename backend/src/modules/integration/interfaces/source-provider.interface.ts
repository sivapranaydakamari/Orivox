import { IRawArtifact } from '../models/raw-artifact.model';

export interface ISourceProvider {
  /**
   * Validate the connection to the external source (e.g., test API keys, tokens).
   */
  validateConnection(connectionData: Record<string, unknown>): Promise<boolean>;

  /**
   * Fetch a list of artifacts based on source-specific filters.
   */
  fetchArtifacts(filterData: Record<string, unknown>): Promise<IRawArtifact[]>;

  /**
   * Fetch a single artifact by its external identifier.
   */
  fetchArtifactById(externalId: string): Promise<IRawArtifact>;

  /**
   * Synchronize updates from the source (delta/incremental sync).
   */
  sync(syncState: Record<string, unknown>): Promise<{ artifacts: IRawArtifact[]; nextSyncState: Record<string, unknown> }>;

  /**
   * Disconnect or cleanup any resources tied to the source connection.
   */
  disconnect(): Promise<void>;
}
