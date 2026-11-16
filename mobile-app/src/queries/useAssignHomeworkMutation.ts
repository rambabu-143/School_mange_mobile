import { useMutation } from '@tanstack/react-query';

import { apiClient, ApiError } from '@/lib/api-client';
import { useSessionStore } from '@/lib/session-store';

/**
 * Native: POST homework — two body shapes depending on assignee (ClassHomeworkPostData for "whole
 * class", StudentsHomeworkPostData when specific students are picked). `attachment` (file upload)
 * isn't wired up yet — server treats it as optional, deferred along with expo-image/document-picker.
 */
export const useAssignHomeworkMutation = () => {
  const token = useSessionStore((s) => s.session?.token);

  return useMutation({
    mutationFn: async (variables: {
      standardSectionId: string;
      subjectId: string;
      text: string;
      date: string;
      studentIds: string[];
    }) => {
      if (!token) throw new ApiError('Not signed in');

      const body =
        variables.studentIds.length === 0
          ? {
              standard_section: variables.standardSectionId,
              text: variables.text,
              subject_id: variables.subjectId,
              date: variables.date,
              attachment: null,
            }
          : {
              students: variables.studentIds,
              selected_section: variables.standardSectionId,
              text: variables.text,
              subject_id: variables.subjectId,
              date: variables.date,
              attachment: null,
            };

      return apiClient.post<{ message?: string }>('homework', body, token);
    },
  });
};
