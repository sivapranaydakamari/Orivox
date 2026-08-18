import mongoose, { Document, Schema, Types } from 'mongoose';

export enum AuthProvider {
  EMAIL = 'EMAIL',
  GITHUB = 'GITHUB',
}

export enum GlobalRole {
  PLATFORM_OWNER = 'PLATFORM_OWNER',
  USER = 'USER',
}

export enum OrgRole {
  ORG_ADMIN = 'ORG_ADMIN',
  MANAGER = 'MANAGER',
  TEAM_LEAD = 'TEAM_LEAD',
  EMPLOYEE = 'EMPLOYEE',
}

export enum ProjectRole {
  PROJECT_ADMIN = 'PROJECT_ADMIN',
  PROJECT_MANAGER = 'PROJECT_MANAGER',
  TEAM_LEAD = 'TEAM_LEAD',
  ENGINEER = 'ENGINEER',
  VIEWER = 'VIEWER',
}

export interface IProjectRole {
  projectId: Types.ObjectId;
  role: ProjectRole;
}

export interface IMembership {
  organizationId: Types.ObjectId;
  orgRole: OrgRole;
  projectRoles: IProjectRole[];
}

export interface IUser extends Document {
  email: string;
  name: string;
  authProvider: AuthProvider;
  providerId?: string;
  passwordHash?: string;
  resetToken?: string;
  globalRole: GlobalRole;
  memberships: IMembership[];
  createdAt: Date;
  updatedAt: Date;
}

const ProjectRoleSchema = new Schema<IProjectRole>(
  {
    projectId: { type: Schema.Types.ObjectId, ref: 'Project', required: true },
    role: { type: String, enum: Object.values(ProjectRole), required: true },
  },
  { _id: false }
);

const MembershipSchema = new Schema<IMembership>(
  {
    organizationId: { type: Schema.Types.ObjectId, ref: 'Organization', required: true },
    orgRole: { type: String, enum: Object.values(OrgRole), required: true },
    projectRoles: [ProjectRoleSchema],
  },
  { _id: false }
);

const UserSchema: Schema = new Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
      match: /^\S+@\S+\.\S+$/,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    authProvider: {
      type: String,
      enum: Object.values(AuthProvider),
      required: true,
    },
    providerId: {
      type: String,
      sparse: true,
      unique: true,
    },
    passwordHash: {
      type: String,
    },
    resetToken: {
      type: String,
    },
    globalRole: {
      type: String,
      enum: Object.values(GlobalRole),
      default: GlobalRole.USER,
    },
    memberships: [MembershipSchema],
  },
  {
    timestamps: true,
  }
);

UserSchema.index({ 'memberships.organizationId': 1 });
UserSchema.index({ 'memberships.projectRoles.projectId': 1 });

export const User = mongoose.model<IUser>('User', UserSchema);
