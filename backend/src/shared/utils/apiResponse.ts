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

  static error(res: Response, error: string, details: unknown = null, statusCode: number = HttpStatus.INTERNAL_SERVER_ERROR) {
    return res.status(statusCode).json({
      success: false,
      error,
      details,
    });
  }
}
