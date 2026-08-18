import { AsyncLocalStorage } from 'async_hooks';

export interface RequestContextData {
  requestId: string;
}

export const requestContext = new AsyncLocalStorage<RequestContextData>();

export function getRequestId(): string | undefined {
  const store = requestContext.getStore();
  return store?.requestId;
}
