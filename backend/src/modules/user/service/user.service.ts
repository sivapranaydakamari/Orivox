import { userRepository } from '../repository/user.repository';
import { IUser } from '../model/user.model';
import bcrypt from 'bcrypt';

export class UserService {
  async getProfile(userId: string): Promise<IUser> {
    const user = await userRepository.findById(userId);
    if (!user) throw new Error('User not found');
    return user;
  }

  async getByEmail(email: string): Promise<IUser | null> {
    return await userRepository.findOne({ email });
  }

  async updateProfile(userId: string, name: string): Promise<IUser> {
    const user = await userRepository.update(userId, { name });
    if (!user) throw new Error('User not found');
    return user;
  }

  async changePassword(userId: string, currentPassword?: string, newPassword?: string): Promise<void> {
    if (!currentPassword || !newPassword) {
      throw new Error('Both current and new passwords are required');
    }

    const user = await userRepository.findById(userId);
    if (!user) throw new Error('User not found');

    if (user.passwordHash) {
      const isMatch = await bcrypt.compare(currentPassword, user.passwordHash);
      if (!isMatch) throw new Error('Incorrect current password');
    }

    const newHash = await bcrypt.hash(newPassword, 10);
    await userRepository.update(userId, { passwordHash: newHash });
  }
}

export const userService = new UserService();
