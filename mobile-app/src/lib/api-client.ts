import Constants from 'expo-constants';

const BASE_URL =
  process.env.EXPO_PUBLIC_API_URL ||
  (Constants.expoConfig?.extra?.apiUrl as string | undefined) ||
  'https://mountcarmelschool.com:4201';

export class ApiError extends Error {
  status?: number;
  /** Second arg: HTTP status number, or standard `{ cause }` options. */
  constructor(message: string, arg?: number | ErrorOptions) {
    super(message, typeof arg === 'object' ? arg : undefined);
    if (typeof arg === 'number') this.status = arg;
  }
}

/** The backend answers "nothing here" with an HTTP 404 or `status:false, "Data Not Found"` — an empty
 * result for list screens, not a failure worth a toast. */
export const isNotFound = (e: unknown) =>
  e instanceof ApiError && (e.status === 404 || /not found/i.test(e.message));

/** Resolve `empty` when the backend says "nothing here"; any other failure still throws. */
export const orEmpty = async <T>(promise: Promise<T>, empty: T): Promise<T> => {
  try {
    return await promise;
  } catch (e) {
    if (isNotFound(e)) return empty;
    throw e;
  }
};


type Envelope<T> = { status?: boolean | null; message?: string | null; data?: T; [key: string]: unknown };

type RequestOptions = {
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE';
  body?: unknown;
  token?: string | null;
};

/** Fetch + parse, no status check — caller decides what `!status` means. */
async function fetchEnvelopeRaw<T>(path: string, options: RequestOptions = {}): Promise<Envelope<T>> {
  const { method = 'GET', body, token } = options;

  const url = `${BASE_URL}/${path.replace(/^\//, '')}`;

  const response = await fetch(url, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token.replace('Bearer ', '')}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  if (!response.ok) {
    if (__DEV__) console.log('[api] HTTP error', response.status, url);
    throw new ApiError(`HTTP error! Status: ${response.status}`, response.status);
  }

  const result = (await response.json()) as Envelope<T> | null;
  if (typeof result !== 'object' || result === null) {
    throw new ApiError('Invalid response format');
  }
  return result;
}

/** Fetch + parse + throw on `!status` — the shape almost every endpoint wants. */
async function fetchEnvelope<T>(path: string, options: RequestOptions = {}): Promise<Envelope<T>> {
  const result = await fetchEnvelopeRaw<T>(path, options);
  if (!result.status) {
    throw new ApiError(result.message || 'Unknown error occurred!');
  }
  return result;
}

async function request<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const result = await fetchEnvelope<T>(path, options);
  // Some endpoints (login) put the payload at the top level rather than under `data`.
  return (result.data ?? (result as unknown as T)) as T;
}

export const apiClient = {
  get: <T>(path: string, token?: string | null) => request<T>(path, { method: 'GET', token }),
  post: <T>(path: string, body?: unknown, token?: string | null) =>
    request<T>(path, { method: 'POST', body, token }),
  put: <T>(path: string, body?: unknown, token?: string | null) =>
    request<T>(path, { method: 'PUT', body, token }),
  delete: <T>(path: string, token?: string | null) => request<T>(path, { method: 'DELETE', token }),
  /** For endpoints where you need sibling fields (e.g. `path`) alongside `data`, not just `data` alone. */
  getEnvelope: <T>(path: string, token?: string | null) => fetchEnvelope<T>(path, { method: 'GET', token }),
  /** For endpoints where `!status` isn't necessarily an error (e.g. a confirmation-required response). */
  postEnvelopeRaw: <T>(path: string, body: unknown, token?: string | null) =>
    fetchEnvelopeRaw<T>(path, { method: 'POST', body, token }),
  /** For endpoints with no `status`/`message` at all (e.g. gallery) — just `{data, path, ...}`. */
  getEnvelopeRaw: <T>(path: string, token?: string | null) => fetchEnvelopeRaw<T>(path, { method: 'GET', token }),
};
