import { Request, Response } from 'express';

export const checkHealth = (req: Request, res: Response): void => {
  res.status(200).json({
    status: 'UP',
    service: 'Engineering Knowledge Assistant',
    version: '1.0.0',
  });
};
