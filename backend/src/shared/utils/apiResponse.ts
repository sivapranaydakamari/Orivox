import { Response } from 'express';
import { HttpStatus } from '../constants/http.constants';

export class ApiResponse {
  static success<T>(res: Response, data: T, message = 'Success', statusCode: number = HttpStatus.OK) {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static error(res: Response, error: string | { code: string; message: string }, details: unknown = null, statusCode: number = HttpStatus.INTERNAL_SERVER_ERROR) {
    const errorObj = typeof error === 'string' 
      ? { code: 'UNKNOWN_ERROR', message: error } 
      : { code: error.code, message: error.message };

    // Do not log or expose stack traces to client in production
    // Internal logs handle the actual stack trace.
    return res.status(statusCode).json({
      success: false,
      error: errorObj,
      ...(details ? { details } : {}), // only include details if truthy to avoid leaking nulls
    });
  }
}
