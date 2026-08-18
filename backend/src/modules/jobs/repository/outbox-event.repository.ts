import { BaseRepository } from '../../../shared/repository/base.repository';
import { IOutboxEvent, OutboxEventModel } from '../model/outbox-event.model';
import { ClientSession } from 'mongoose';

export class OutboxEventRepository extends BaseRepository<IOutboxEvent> {
  constructor() {
    super(OutboxEventModel);
  }

  async createEvent(data: Partial<IOutboxEvent>, session?: ClientSession): Promise<IOutboxEvent> {
    const createdEntity = new this.model(data);
    return await createdEntity.save({ session });
  }
}

export const outboxEventRepository = new OutboxEventRepository();
