import { queueService } from '../queue.service';
import { outboxEventRepository } from '../repository/outbox-event.repository';
import { OutboxEventStatus } from '../model/outbox-event.model';
import { logger } from '../../../config/logger';

export class OutboxProcessor {
  private isProcessing = false;
  private intervalId?: NodeJS.Timeout;

  start(intervalMs = 5000) {
    if (this.intervalId) return;
    logger.info('Starting Outbox Processor');
    
    this.intervalId = setInterval(() => this.processOutbox(), intervalMs);
    // Initial run
    this.processOutbox();
  }

  stop() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = undefined;
    }
  }

  private async processOutbox() {
    if (this.isProcessing) return;
    this.isProcessing = true;

    try {
      // Find up to 50 pending events
      const events = await outboxEventRepository.findMany({ status: OutboxEventStatus.PENDING });
      const pendingEvents = events.slice(0, 50); // Simulating limit if findMany doesn't support it directly in BaseRepository

      for (const event of pendingEvents) {
        try {
          // Enqueue to BullMQ
          await queueService.enqueue(event.jobType, event.payload);
          
          // Mark as processed
          await outboxEventRepository.update(event._id.toString(), {
            status: OutboxEventStatus.PROCESSED,
          });
        } catch (err) {
          logger.error({ err, eventId: event._id }, 'Failed to process outbox event');
          await outboxEventRepository.update(event._id.toString(), {
            status: OutboxEventStatus.FAILED,
            error: err instanceof Error ? err.message : String(err),
          });
        }
      }
    } catch (error) {
      logger.error({ err: error instanceof Error ? error.message : error, stack: error instanceof Error ? error.stack : undefined }, 'Error in outbox processor sweep');
    } finally {
      this.isProcessing = false;
    }
  }
}

export const outboxProcessor = new OutboxProcessor();
