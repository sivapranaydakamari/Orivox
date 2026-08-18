import { Application } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';

export const configureSecurity = (app: Application) => {
  app.use(helmet());
  app.use(cors());
  app.use(compression());
};
