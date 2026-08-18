import { Router } from 'express';
import { knowledgeController } from '../controller/knowledge.controller';
import { validate } from '../../../middleware/validate.middleware';
import { getKnowledgeRecordSchema, getKnowledgeQuerySchema } from '../validation/knowledge.validation';

const router = Router();

router.get('/', validate(getKnowledgeQuerySchema), knowledgeController.getAll);
router.get('/:id', validate(getKnowledgeRecordSchema), knowledgeController.getById);

export default router;
