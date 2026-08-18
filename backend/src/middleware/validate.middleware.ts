import { Request, Response, NextFunction } from 'express';
import { ZodSchema, ZodError } from 'zod';
import { ApiResponse } from '../shared/utils/apiResponse';

export const validate = (schema: ZodSchema) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      return next();
    } catch (error) {
      if (error instanceof ZodError) {
        return ApiResponse.error(res, 'Validation Error', error.issues, 400);
      }
      return ApiResponse.error(res, 'Internal Server Error', null, 500);
    }
  };
};
