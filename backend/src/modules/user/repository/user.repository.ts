import { BaseRepository } from '../../../shared/repository/base.repository';
import { IUser, User } from '../model/user.model';

export class UserRepository extends BaseRepository<IUser> {
  constructor() {
    super(User);
  }
}

export const userRepository = new UserRepository();
