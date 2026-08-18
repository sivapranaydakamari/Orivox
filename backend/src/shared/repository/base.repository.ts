import { Model, Document, Types, ClientSession } from 'mongoose';

export abstract class BaseRepository<T extends Document> {
  protected constructor(protected readonly model: Model<T>) {}

  async create(data: Partial<T>, session?: ClientSession): Promise<T> {
    const createdEntity = new this.model(data);
    return await createdEntity.save({ session });
  }

  async findById(id: Types.ObjectId | string): Promise<T | null> {
    return await this.model.findById(id).exec();
  }

  async findOne(filter: Record<string, any>): Promise<T | null> {
    return await this.model.findOne(filter).exec();
  }

  async findMany(filter: Record<string, any>): Promise<T[]> {
    return await this.model.find(filter).exec();
  }

  async update(id: Types.ObjectId | string, data: Record<string, any>, session?: ClientSession): Promise<T | null> {
    return await this.model.findByIdAndUpdate(id, data, { new: true, session }).exec() as unknown as T | null;
  }

  async findOneAndUpdate(filter: Record<string, any>, data: Record<string, any>, session?: ClientSession): Promise<T | null> {
    return await this.model.findOneAndUpdate(filter, data, { new: true, session }).exec() as unknown as T | null;
  }

  async upsert(filter: Record<string, any>, data: Record<string, any>, session?: ClientSession): Promise<T> {
    return await this.model.findOneAndUpdate(filter, data, { new: true, upsert: true, session }).exec() as unknown as T;
  }

  async delete(id: Types.ObjectId | string): Promise<T | null> {
    return await this.model.findByIdAndDelete(id).exec();
  }

  async deleteMany(filter: Record<string, any>): Promise<any> {
    return await this.model.deleteMany(filter).exec();
  }

  async bulkWrite(operations: any[], options?: Record<string, any>): Promise<any> {
    return await this.model.bulkWrite(operations, options);
  }
}
