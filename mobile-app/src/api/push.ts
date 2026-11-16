import { apiClient } from '@/lib/api-client';

/** Native: PUT staff/update-device/{id} (staff) or PUT student/detail/update-device/{id} (student/parent) */
export const updateDeviceToken = (
  authToken: string,
  userId: string,
  isStaff: boolean,
  deviceToken: string
) =>
  apiClient.put(
    isStaff ? `staff/update-device/${userId}` : `student/detail/update-device/${userId}`,
    { token: deviceToken },
    authToken
  );
